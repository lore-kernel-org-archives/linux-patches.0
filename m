Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D321E1E47CE;
	Mon, 21 Oct 2024 10:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507543; cv=none; b=ESAJI+puyrD79SYthHuxc/3Ra8SUIxlUA5dyzFyctXQHx4c3Iul8ABWR0kl8013xVnrZ2RgTZVfKfSLxwwnFELE4wf5LNMfdqn/l3vtrLS8Zd08j7pEkwg+SeMeLbi2PJpgaMcw9X/0wJNHlTS5TfQ9cjYhnDyK7OQnXlBlfkzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507543; c=relaxed/simple;
	bh=S+dTmz6B2Cx8QehcW2AoQN4UqbAvq10py/Pt9qcaDEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehTZYif3H9AqmSRohjlc5NX+VXXosCUmbHXEa9Ao1ny61Kl0CyaPOp3L6wJoTLB00W6qUGITZNYXpjzkWxuzIWGxtfSNMDLU8RdtI58YBa6uJwKOBJeeTHI+YkhLJPit0Vf3XJrMcVCFF/dj0jOp/ZOqtejn/Df9JCcpGIdUtpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWjZpNli; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWjZpNli"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5568DC4CEC3;
	Mon, 21 Oct 2024 10:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507543;
	bh=S+dTmz6B2Cx8QehcW2AoQN4UqbAvq10py/Pt9qcaDEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWjZpNliV5WH7vO/5/w99NLMUfdDfUyqNmB90JNrU6c3nyHNOEhPsDeWzc6REvavU
	 mXgs5FaAnGpApveM6HMPMIFOMmOaws/pJ5S/SCx2sxSk3i3lghW2uAUYPm+f9zca1A
	 ezudc/XP/rAhpoOPSChaO5mJt6iI5AM/cYe2F75E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d31185aa54170f7fc1f5@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 21/82] udf: Fix bogus checksum computation in udf_rename()
Date: Mon, 21 Oct 2024 12:25:02 +0200
Message-ID: <20241021102248.089187706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102247.209765070@linuxfoundation.org>
References: <20241021102247.209765070@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit 27ab33854873e6fb958cb074681a0107cc2ecc4c ]

Syzbot reports uninitialized memory access in udf_rename() when updating
checksum of '..' directory entry of a moved directory. This is indeed
true as we pass on-stack diriter.fi to the udf_update_tag() and because
that has only struct fileIdentDesc included in it and not the impUse or
name fields, the checksumming function is going to checksum random stack
contents beyond the end of the structure. This is actually harmless
because the following udf_fiiter_write_fi() will recompute the checksum
from on-disk buffers where everything is properly included. So all that
is needed is just removing the bogus calculation.

Fixes: e9109a92d2a9 ("udf: Convert udf_rename() to new directory iteration code")
Link: https://lore.kernel.org/all/000000000000cf405f060d8f75a9@google.com/T/
Link: https://patch.msgid.link/20240617154201.29512-1-jack@suse.cz
Reported-by: syzbot+d31185aa54170f7fc1f5@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/udf/namei.c |    2 --
 1 file changed, 2 deletions(-)

--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -857,8 +857,6 @@ static int udf_rename(struct user_namesp
 	if (has_diriter) {
 		diriter.fi.icb.extLocation =
 					cpu_to_lelb(UDF_I(new_dir)->i_location);
-		udf_update_tag((char *)&diriter.fi,
-			       udf_dir_entry_len(&diriter.fi));
 		udf_fiiter_write_fi(&diriter, NULL);
 		udf_fiiter_release(&diriter);
 


