Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D06230BD4;
	Mon, 10 Mar 2025 17:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628303; cv=none; b=B0qVJAEaWCkkjCD7AabSNR8+AyXKHkT9angUL4PZCPN4NKxY5dT3pCixhMzHBSpiwtBRE5RuU3wStUQ6IIM0JPxjHB8Pql3PPbWt2avDQ6WZ9bPV2reqhAdIuJRclOGk3WoIrQVHV+xZqSVzwt9BpeWH7KRUYd0m6UjtTvmEuZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628303; c=relaxed/simple;
	bh=gkHi7o13ETXRJyofAOsnn5EWC5EYg8Dmf4u/D4hsxDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i2slh1jJiYUf1DLVHGAasD4cK75u7SyPT0ytjWN4BAfbkoWSbePZXhgyD87ewbnDN+SuUsqn7WlBJWmOsF6xo8P1PaLwXvP/qjhlQqGQwEZr8xMs5lz2w/s/sgFDqG6VWUlErslK37q/ajnyxItCqPhGoHXwJV+eDjPRki/COuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZmq0u9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZmq0u9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8EBCC4CEE5;
	Mon, 10 Mar 2025 17:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628303;
	bh=gkHi7o13ETXRJyofAOsnn5EWC5EYg8Dmf4u/D4hsxDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZmq0u9d1j6Vi64mPPcD/94pTgBr2vf+Soz49LpP371aiGWSiSrq9zHM7JciBwvlH
	 Hyhr6a+Ghr5E+aAaqs7W2U74t/IGwhEQy4sEPdMprqKqVFEAkBnHuikqI91w6Ns2KD
	 rTLGjrbbByGv7Gpcipc7rbu734OfDnk+71VZmybU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.1 012/109] ksmbd: fix use-after-free in smb2_lock
Date: Mon, 10 Mar 2025 18:05:56 +0100
Message-ID: <20250310170428.038762044@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
References: <20250310170427.529761261@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

commit 84d2d1641b71dec326e8736a749b7ee76a9599fc upstream.

If smb_lock->zero_len has value, ->llist of smb_lock is not delete and
flock is old one. It will cause use-after-free on error handling
routine.

Cc: stable@vger.kernel.org
Reported-by: Norbert Szetei <norbert@doyensec.com>
Tested-by: Norbert Szetei <norbert@doyensec.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/server/smb2pdu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -7124,13 +7124,13 @@ out_check_cl:
 		}
 
 no_check_cl:
+		flock = smb_lock->fl;
+		list_del(&smb_lock->llist);
+
 		if (smb_lock->zero_len) {
 			err = 0;
 			goto skip;
 		}
-
-		flock = smb_lock->fl;
-		list_del(&smb_lock->llist);
 retry:
 		rc = vfs_lock_file(filp, smb_lock->cmd, flock, NULL);
 skip:


