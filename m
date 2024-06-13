Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DFC144D2F;
	Thu, 13 Jun 2024 12:10:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280647; cv=none; b=ii2kF2qLOyVtl4jDazb9BjS9zyOdittlnU51zSrvYmgSUq0YS3cWvXXSJFD27E7QETt/+3a2ypQOrevzJndBr1gIeu03TGuDGZpP7oCSJCaya1puHAGsVpvxFWnjQznX9t5SQH+IM9ah8PwjKB3qDpnWNAZJa8Q5H7orLnLQxPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280647; c=relaxed/simple;
	bh=D8RiNhwJuEUxV+S49JdjYhW9HuuZmbuFK8it5GLDNL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHAFP6BMwY8Z2CRJSI9BpP2rYgppbRq4BhjSptuVNb2ioYM2PK3AMM4dZo7XQ/HlsLkAkUlz9b8+VQbzXaAW+9mDrUjFg4DX2Prp/EKXzZZSEWXm6TpmMn/mfVe6tKynsZtQnMAOIG2k+3EiH7NTnVhqrDnPM8P7mcVrWYAm2UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJDZuQJJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJDZuQJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD754C2BBFC;
	Thu, 13 Jun 2024 12:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280647;
	bh=D8RiNhwJuEUxV+S49JdjYhW9HuuZmbuFK8it5GLDNL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJDZuQJJWTQvM0+0VoKeo5h9iHe6d1EsDZTaHJAMpKo56L6/ahuj9Nk1iEomlyl88
	 m0TK5Mj/wyyaANw6n0MvHgfN1V4JYKKECObYoE/QODR5PiGLJYPN4WounqpmEbt6+1
	 Z9ZQAuISRjQXLIQvrGiul5HgZp2+ejojiwoTu2Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 107/137] ext4: Fixes len calculation in mpage_journal_page_buffers
Date: Thu, 13 Jun 2024 13:34:47 +0200
Message-ID: <20240613113227.448926547@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

commit c2a09f3d782de952f09a3962d03b939e7fa7ffa4 upstream.

Truncate operation can race with writeback, in which inode->i_size can get
truncated and therefore size - folio_pos() can be negative. This fixes the
len calculation. However this path doesn't get easily triggered even
with data journaling.

Cc: stable@kernel.org # v6.5
Fixes: 80be8c5cc925 ("Fixes: ext4: Make mpage_journal_page_buffers use folio")
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/cff4953b5c9306aba71e944ab176a5d396b9a1b7.1709182250.git.ritesh.list@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2342,7 +2342,7 @@ static int mpage_journal_page_buffers(ha
 
 	if (folio_pos(folio) + len > size &&
 	    !ext4_verity_in_progress(inode))
-		len = size - folio_pos(folio);
+		len = size & (len - 1);
 
 	return ext4_journal_folio_buffers(handle, folio, len);
 }


