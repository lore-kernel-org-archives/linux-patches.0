Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045705;
	b=rK5XJPTgO4nqZLKrXIqxG47i2pVy97/VeVkEtsIYvgYm+5s9+tu9EHcqdp3KWlNOPTAJ
	 fIdSgqzayegM3RvmyNHpUrDFSH17vJlWbtpr6JfQLMiQg3CTulN9CIFhyULuW1SePAsSg
	 oYquzZxZ/Q+tClDackANX5rTqnIefniBMEwG1QrHTE2KUjcG4EmzGIoGcKKii5f+myOCL
	 NPWzH0OXhtMdnVXWP6mF8UqVtiUJm6MHqlpUq9U+AJwqRseRazNzVlStpSU3I0uLQvbTk
	 DZs7O9bOpHEO/N4yfULwgtyYmEDyYmUpfdXwlNb9a+gxFgtd7buRe1TGaSqCscFZwoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045705;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gEd+5zp3FuO/6CCY+dLOSP8p4Lhf4uWQ7YVMuJ5YSE4=;
	b=0mXUmqa2eKW6q4VzAIiFNFAE/7W80eGotyQIMTUhPJbYH1vw3wKoWnPptxpOSWpJ1zaA
	 zgrPTZ2sjdoUNhK/oNfKmsWAcULcYWh5PTdcbSsXgVa5pOb5ci2b97f2iGQpNk8ObI0lv
	 +8m0J10UDGIQ3q/XOFHyBu1eHVg8HGdPk3ffjhjEQdCYBxYuBSk+3hwgi5OyVqV0jJPyi
	 +SVXmHwy9ZE3fPXXHptFehMT+1N/CVWj1uGIu5dSeTqibE08SHJdxiCzqBPXcTJ7Nin1K
	 4C05odm4lKZFdTkTjHRFx+EBsBK1OWGLtXYKIce8P4VkNW52TxW7gPDuyA9lger2Lvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="KYZPz/u2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DAB9606A325;
	Wed, 18 Nov 2026 23:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KYZPz/u2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14A11F000C4;
	Wed, 18 Nov 2026 23:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045705;
	bh=gEd+5zp3FuO/6CCY+dLOSP8p4Lhf4uWQ7YVMuJ5YSE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KYZPz/u2IBSSMleJ83s6jju3ix0aT+aknPnyiZCq28TVnRiPv44pma615xEXBbp8y
	 /y9KAVkynIs8jf8KOtEDZ2/zRjc3JPLewqwu1AnW09Eb17Pa+cSaFKu5XRy7q4STVI
	 qzlKmu6gGDty/uD3n2cM26pxF+v37XWdWXPtNA0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1018/2857] writeback: clear old wb dirty state after inode switches
Date: Wed, 18 Nov 2026 15:34:12 +0100
Message-ID: <20261118150238.250951017@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7066cc78879e7..f82d5d70a6cd0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -509,6 +509,7 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		}
 	}
 
+	wb_io_lists_depopulated(old_wb);
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 
-- 
2.53.0



