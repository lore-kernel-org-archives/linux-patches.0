Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160B63D7D67;
	Wed, 20 May 2026 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296676; cv=none; b=aWBy81xy5VI1h9Gy4lQuSNcms+ogsMg6IxusENKSJ5mZI6c1ItEv9ubTzYo70Ct1IQPDrlw2LdOOZp2VBC/Z97KCSx9cfpV0sjRUxztgJ/38SOs764qmxFLk3C3Hb8K9S866EIW5Sn+6u/uWE79CVl1WjqEaJJcGwplYzlaloow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296676; c=relaxed/simple;
	bh=awGYmycK++4agAUPoGtL+tj6DumV3AGDyLueI1mytoc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfXYcO/tloseHvwfbaATC0G/sSsneiEwbAz7A3JJOavrk17Ez22F+mfj6HnF+NII1aiOsVBh0jYwIW2pEXvPiPqCKCAWPKUb891nHSGQWF+QKIQwaYeGerBHq6G/1UWyjixfTKgGUmrjYDpCd3rgX5/O1LzrgFd2DZUhI147JD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=drYsLK36; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="drYsLK36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3001F00893;
	Wed, 20 May 2026 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296674;
	bh=Sn7LSxzjjYTYKrHbTe1ULwcL6654ByeYkJZu8YY6FTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drYsLK36/3EowpXh9d3BOl4b+QD0j2MwOO1e+i9wfeV9MxrZAEHgJOUqGNPUffUxc
	 XEyGc+X6cc0LANiG/3odlKKXG1FlRNED+dYPEsDB2UQL0rsFnZk4ARDDc8FXPLlRWV
	 gkE+/l1PeU5n5iulMeBzyMJrF49iZamxiBHUmngQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Mark Harmstone <mark@harmstone.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0889/1146] btrfs: fix bytes_may_use leak in move_existing_remap()
Date: Wed, 20 May 2026 18:18:59 +0200
Message-ID: <20260520162208.356497654@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Harmstone <mark@harmstone.com>

[ Upstream commit 68a135013bf73dfd6a277f76fc4e088b0f3dfa79 ]

If the call to btrfs_reserve_extent() in move_existing_remap() returns a
smaller extent than we asked for, currently we're not undoing the
bytes_may_use change that we made. Fix this by calling
btrfs_space_info_update_bytes_may_use() again for the difference.

Fixes: bbea42dfb91f ("btrfs: move existing remaps before relocating block group")
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Mark Harmstone <mark@harmstone.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/relocation.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index 033f74fd6225c..6e260ccbf50ac 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -4182,6 +4182,12 @@ static int move_existing_remap(struct btrfs_fs_info *fs_info,
 		return ret;
 	}
 
+	if (ins.offset < length) {
+		spin_lock(&sinfo->lock);
+		btrfs_space_info_update_bytes_may_use(sinfo, ins.offset - length);
+		spin_unlock(&sinfo->lock);
+	}
+
 	dest_addr = ins.objectid;
 	dest_length = ins.offset;
 
-- 
2.53.0



