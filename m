Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031575;
	b=lF49BNILctPNXg0kWzYFToNRQTJHTDsQFgITswfOP6gDi+sQYQaYVyIGFA+HI1goMtGL
	 nHJ+26g+vOQfbs8SZOqc5cRZceG8OLOt1UGwZYgu/nTL66+RyZwHQazS6N6uELyL4iCqt
	 lz6CsjtmzVn3BG/2+WSe8PC+zZkvhx5fc+rQBg3xX6g0nAIO5BkkQyxLgnDrvVGRG5ecK
	 putskCmLMdwdvve3QqpIwzZBhJbzG3VwjGnDgo/YQcBCMOE6HFCLNcWQ2f2M0JR6VSyzo
	 lxDV6Sj2x/BazKxy6tTYJEcZYOVJHlqtWXdQoI9CCMqN11ksuBbquwt44Qo7v8LG0lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031575;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o5cnB/c+GXgclET8K52/EuAcIbfTPRGZ9SmoFlRDa7s=;
	b=y3jfH3gGOY7l2bMgbVfKMrqJA9SkA08lKa+VtqsrbJDXaRDnAkwxAQo7mY4kQvpTe+lJ
	 EBsmelakjhoildiEJCHIlagbJajwsc6svfjPXiB/h5CksdRcAfyC8VCSY+gvFyecWqvlG
	 zwbXCM5dxYDIEhH/+vcfqf0pnDoF6xpU1ArWl/MS+Qn8YJKbtK+iVgm8a7Op/yG2FiA4c
	 oQtUKyAdD/ksdPIPKFF7gTR4jbz6t1iDPXHSz3ezrelXNFJwRjldb0bsjZhmUbbnRV3tD
	 T2Zu20iP+wsMKzm/xb2D420UNRYO7v5+Fuphdc575EL6UFyK/ga1NpUDysQqkk0ovhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIXzcXaW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C7A606A31C;
	Wed, 18 Nov 2026 19:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bIXzcXaW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85F51F000C4;
	Wed, 18 Nov 2026 19:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031575;
	bh=o5cnB/c+GXgclET8K52/EuAcIbfTPRGZ9SmoFlRDa7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bIXzcXaWc03LoqKO14FUIzbQkS5GmZHxcQwXU/+axRuk4EDWUvsDMMGvVLn7PT2kf
	 1jVNgJCPWlGSJak+EYf9eXlohFbrVv4FWvsLjgzJTApkaENpLF33SBMZtWifWq7d7S
	 +UprjD80BnzbLgFPSIHRrcUuAxmQSgXrBI/o50cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1065/1756] btrfs: fix off by one super block end offset calculation when writing super blocks
Date: Wed, 18 Nov 2026 15:53:12 +0100
Message-ID: <20261118150052.649093635@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit 7884a8f3279c28ff990e2eacd5c2479bb1c930d0 ]

We are skipping the write of a super block mirror if its end offset
matches exactly the device's end offset. This happens because we are using
a greater than or equals comparison instead of just a greater than
comparison.

Fixes: 935e5cc935bc ("Btrfs: fix wrong disk size when writing super blocks")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d1f245ef1911f..e49072f7ea027 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3744,8 +3744,7 @@ static int write_dev_supers(struct btrfs_device *device,
 			atomic_inc(&device->sb_write_errors);
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		btrfs_set_super_bytenr(sb, bytenr_orig);
@@ -3828,8 +3827,7 @@ static int wait_dev_supers(struct btrfs_device *device, int max_mirrors)
 				primary_failed = true;
 			continue;
 		}
-		if (bytenr + BTRFS_SUPER_INFO_SIZE >=
-		    device->commit_total_bytes)
+		if (bytenr + BTRFS_SUPER_INFO_SIZE > device->commit_total_bytes)
 			break;
 
 		folio = filemap_get_folio(device->bdev->bd_mapping,
-- 
2.53.0



