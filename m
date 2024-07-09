Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784ED14EC4D;
	Tue,  9 Jul 2024 11:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523825; cv=none; b=B+5LqbO4aLiT/4pRyxyfoVUDJ/u1utqt/Jpp2dOYG1vwXz51xXsVWR7gpCUDoLAtxU5pkBStepu0eIAqBdYmkxMF8DyARPVFcNRmZJAUtzHx54vNz+e/LWmqrrI9Obj+8EiGHr1SCQcJR1FCZBHY7ebfQKo3msohCzZZo8xlO8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523825; c=relaxed/simple;
	bh=Xg843TkaDa1FXTZXIIvx/Cyo/PtP/dze3aKun8tsjKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OC1FF9q+h00Z1wR0Uy/7l0kCtSMaHt9L8jslf8vL3mQgA1+zWcr3QNwHeNmWjrIufhcVG0DMi7WUNj4MqMEKBfk8yOMWnj+HvN6Lshw1ckSP1G/+xMAP3TnPcqVIJHGq3H55RoOcRcPumVeQXGGnc4Lg2mw9aZD+FNo5fqIJKNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=giqlspo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="giqlspo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F77C3277B;
	Tue,  9 Jul 2024 11:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523825;
	bh=Xg843TkaDa1FXTZXIIvx/Cyo/PtP/dze3aKun8tsjKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=giqlspo2pQbUSopT8RPvSHy7LfAMms3E0RqVhSsjctVMOvG762bYNesxXcYwZby9s
	 JV1sDsahXM0EOTfDaYT2Nu21O8t6XcWu3UotQi9t4gM1jJdcpNxX/YUy3edix0bKJo
	 rcr0u2cjEhcino/2C5x+zg/ex/DyLCeENELedn6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/139] fs/ntfs3: Mark volume as dirty if xattr is broken
Date: Tue,  9 Jul 2024 13:10:22 +0200
Message-ID: <20240709110702.887539724@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 24f6f5020b0b2c89c2cba5ec224547be95f753ee ]

Mark a volume as corrupted if the name length exceeds the space
occupied by ea.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/xattr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/xattr.c b/fs/ntfs3/xattr.c
index b50010494e6d0..72bceb8cd164b 100644
--- a/fs/ntfs3/xattr.c
+++ b/fs/ntfs3/xattr.c
@@ -219,8 +219,11 @@ static ssize_t ntfs_list_ea(struct ntfs_inode *ni, char *buffer,
 		if (!ea->name_len)
 			break;
 
-		if (ea->name_len > ea_size)
+		if (ea->name_len > ea_size) {
+			ntfs_set_state(ni->mi.sbi, NTFS_DIRTY_ERROR);
+			err = -EINVAL; /* corrupted fs */
 			break;
+		}
 
 		if (buffer) {
 			/* Check if we can use field ea->name */
-- 
2.43.0



