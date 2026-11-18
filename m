Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036814;
	b=IaHNSqmPEEuXoLcWR3JEFMGCC0p90ZaLep4R0DOvIc+tIMJFxZE7xNVg2BD/ySXeliJH
	 E1hb4xjeO5zqR2eowDKcc6IwzW90tdFUkliGrQR0kqIb3ghkvuSBqGnDyI6IySR/0NpGz
	 di71VYcSMnl0uyjLBsAJobk4yW6v33dbvn8gjvsGLyiUj7dMTfSNeqOjzcAa+naX/ph79
	 AOBF1N3KI8cfeSMeLkB+3areXyZ+bIg8Wtp7G6LU/Up5CGTwRZ08Otyu2P4YmFEmTZ6yf
	 Dn2wa0+vFy8ddvPqkpyMgtBBzpgpxdFpeyuFawZCJqIf4f3i5cCXqceK36/Dn6PiQ7Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036814;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FEk723YZX9AoHZVwRPUuIc3+l8rQ9BFZ40IxcYwCp9U=;
	b=FP8As1cNo9HU3Qk+nfNHF1yCG6Itnv/bRdb0nX2myDYFWJ7LYsf27Kpgtx6IjwMQH5ro
	 63vFhGihx3YdknMZKlT92VGbVi/3TYo20dJh1BAXc6Ofr9iNdMgsP126sOFBen6GLaOIN
	 fMkE2nmL0wmUUyKjjOpijpupKPNEYdI5k+72zihwEReHK1zPQoNOVzOax8hDKSH7YIYox
	 eAsRpKHDDT+ALNcHQcgleVCSvdDgtKnZnssqo6yPEtluMCpuVs9ijWa42nz2yKaZoGlJi
	 pw0y4bgLqYRCD8ovzllEE19cOJYpRSbjaiZr35qzc4YRDKmqqQYIO0cyXyC4sDu9FZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zn0o6HWo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D4A606A320;
	Wed, 18 Nov 2026 21:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zn0o6HWo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C3B1F000C4;
	Wed, 18 Nov 2026 21:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036814;
	bh=FEk723YZX9AoHZVwRPUuIc3+l8rQ9BFZ40IxcYwCp9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zn0o6HWoKvZRIJmV1/N9YOjBV/7suR0DTxVt5kmv4v212ZdNNBz2Y2+6LLrCntKDe
	 DYOnCZqOfT/KboFO6WaMnOQ1jV784GU+pT5ME9dZcdcf33UIoCcLIjhe0ChlpSt3Iu
	 NTj7/BmrCUKVF1+zS8Sq1ZJd7USEVWxdWp8X2pHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1192/3318] writeback: clear old wb dirty state after inode switches
Date: Wed, 18 Nov 2026 15:30:14 +0100
Message-ID: <20261118150355.926482360@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 276e202f9b6f3..c9fe6a5974713 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -511,6 +511,7 @@ static void process_inode_switch_wbs(struct bdi_writeback *new_wb,
 		}
 	}
 
+	wb_io_lists_depopulated(old_wb);
 	spin_unlock(&new_wb->list_lock);
 	spin_unlock(&old_wb->list_lock);
 
-- 
2.53.0



