Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065209;
	b=0AK2vQFBt93nxDpkikjJiNCG2MWeQKQ65v+ZO3fRmZVXVM5NHE8zc/m0rbZPohhfBp5u
	 l4PO/nrEDll1qldrdpeJkc2pdZoqwwGEiJuY8Ikauqaj2Udw8ziXno8GAdQCVxK/ZjgVk
	 /QeBVkI5Eg6VjTJA9eSud75vxC0SRNpJ58PCWlT4zLJ8SDfSJzmD7GbfmclWMdznKVuKO
	 CBz1gPyquRrG2GQh78jSq9sdp+Ngmwc24iWDF1EvzYvJ4GBh1glHoo84zFbwZVN+dLJ1/
	 tcSNYCGBEaMP5vDlsNRKuYW1y+ontzSup4tz7HZoFyef5yqXrC1NUhzH9Rjqq7vKcZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065209;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gCUi8zrL9FiCqVQ89fuKpNI0kMjKRQ7lQsuBDwuQt7w=;
	b=aEXSyNPBzak+xSSpYmsY5lerAdtbSLMD8dZYIz7w81/U9TQPkaQzgrU9qYtBWOG2Ln7Y
	 17K1XKiA7WOoVGjfUZssJw2NYSkd225y/MEvi7FfO1P/xfaml2VpvGF1nm+4IvJ/WYSMy
	 RmF/AoILghdOwmoZ/1b0uisFt5eBRswAfIfE3uic6px4t4tLCzKXxzR/xvyAY/hE9TyQX
	 cwI+CVR5pg5B9H1nrpSMQ9w0jVxO4ay2x02YXHBlWlBWcxFUkBCC2SKBRXtMm5DVrQV8v
	 qbW0BmrpWWptYIAtC99y8nLhihIznl2yu83RgFfxonOKCaIgHS4qS1z4QBXFpDCk7fQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="RAYcnK+/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD63606A33D;
	Sat,  7 Nov 2026 15:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RAYcnK+/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEC11F0089F;
	Sat,  7 Nov 2026 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065209;
	bh=gCUi8zrL9FiCqVQ89fuKpNI0kMjKRQ7lQsuBDwuQt7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RAYcnK+/M7bVweaEiS3Nk8KGn9awefxBO5apMROSuC/6rOCHLocFL8Td8Nb4k9pXg
	 evi8xhTWE7XPb1TOhJZuOEOsanKxiynWkADi4BhRFgCKlads5CVYS39TTrZRlqnXjo
	 lMfZGM7zE6e1Hswsm6OcgFnYsWlmkrZLWZkS3Nw8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1005/1257] writeback: clear old wb dirty state after inode switches
Date: Sat,  7 Nov 2026 08:55:01 -0500
Message-ID: <20261107135007.101109286@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit a396fe9f74ea367ae3fab2dcb70b24e83db9f0cb ]

Switching an inode to another wb updates the target wb's dirty-I/O state,
but no longer checks whether the source wb's dirty-I/O lists became empty.
The check was lost when inode_io_list_del_locked(inode, old_wb) was
removed to support tracking clean attached inodes.

If the last dirty inode is moved, WB_has_dirty_io remains set on the old
wb and its bandwidth contribution remains in bdi->tot_write_bandwidth.
This can keep an empty wb scheduled for periodic writeback and overstate
the total bandwidth used to distribute writeback work.

Call wb_io_lists_depopulated() on the old wb after the batch of inode
switches, while its list_lock is still held. This clears the flag and
removes the bandwidth contribution if its dirty-I/O lists are empty.

Fixes: f3b6a6df38aa ("writeback, cgroup: keep list of inodes attached to bdi_writeback")
Cc: stable@vger.kernel.org
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Link: https://patch.msgid.link/20261016115230.3640770-3-sunjunchao@bytedance.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 430cf3da58805..1b5b4e9ff5a52 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -566,6 +566,7 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		}
 	}
 
+	wb_io_lists_depopulated(old_wb);
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 
-- 
2.53.0



