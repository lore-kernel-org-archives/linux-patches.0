Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560774AEDF;
	Mon,  1 Apr 2024 16:58:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990701; cv=none; b=ZSupHsYyQeIRo3pvYtRdju/VxANv6JlseLZmxnU4qXghg7xWE9ea8xCSSmUzaMje+8GVTADbd90r9P4hoBA0cz5hrbjqaloBkdRk10FL1W41Zx29qMJCyLTibSQHbIe07AnJDweoFBQxsyqZDlMC1A7plPgiwdhnfnmLmx319Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990701; c=relaxed/simple;
	bh=gZM9cEBl3YzT04zq4u6r8oIQm25qIoKrjAfv95D3FLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOM/fyfA3pVtcTr+KycsaXrZcuJLP2uK2hUHnLLciPYqmcT7MuMZGe52LCgL2e5ybd6VdEZq4859+C75Bhp8HniIQqG8U/kyUOtbZxjxA9pOkexXFr9P1pqCsqNeWadPAD4/kzn9O+acSPgGD4VrzlPR8AzLRl4u2cg0uWqr1Qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wzf0DyCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wzf0DyCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBCCAC433C7;
	Mon,  1 Apr 2024 16:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990701;
	bh=gZM9cEBl3YzT04zq4u6r8oIQm25qIoKrjAfv95D3FLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wzf0DyCj9YQdI1rvZECEW01OO8xxZybzc+E6hMzZUwmbm74ctF7ko9Jq/DQI1aUre
	 f1Skt42Bgg4whTSv2Il6jlR1uHEM7DUwuYGMQrrof17pjhd8sUmX3vRAt0rGQ7bAnC
	 1b3qtHmsTEkNPJ5mGyI+5YGvK+IQ6FfszmKP2F4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3ce5dea5b1539ff36769@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Amir Goldstein <amir73il@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/272] fat: fix uninitialized field in nostale filehandles
Date: Mon,  1 Apr 2024 17:43:49 +0200
Message-ID: <20240401152531.599013681@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

[ Upstream commit fde2497d2bc3a063d8af88b258dbadc86bd7b57c ]

When fat_encode_fh_nostale() encodes file handle without a parent it
stores only first 10 bytes of the file handle. However the length of the
file handle must be a multiple of 4 so the file handle is actually 12
bytes long and the last two bytes remain uninitialized. This is not
great at we potentially leak uninitialized information with the handle
to userspace. Properly initialize the full handle length.

Link: https://lkml.kernel.org/r/20240205122626.13701-1-jack@suse.cz
Reported-by: syzbot+3ce5dea5b1539ff36769@syzkaller.appspotmail.com
Fixes: ea3983ace6b7 ("fat: restructure export_operations")
Signed-off-by: Jan Kara <jack@suse.cz>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fat/nfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
index af191371c3529..bab63eeaf9cbc 100644
--- a/fs/fat/nfs.c
+++ b/fs/fat/nfs.c
@@ -130,6 +130,12 @@ fat_encode_fh_nostale(struct inode *inode, __u32 *fh, int *lenp,
 		fid->parent_i_gen = parent->i_generation;
 		type = FILEID_FAT_WITH_PARENT;
 		*lenp = FAT_FID_SIZE_WITH_PARENT;
+	} else {
+		/*
+		 * We need to initialize this field because the fh is actually
+		 * 12 bytes long
+		 */
+		fid->parent_i_pos_hi = 0;
 	}
 
 	return type;
-- 
2.43.0



