Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831572;
	b=cgAbOG/pABCYgk/zBUIN+wN1LEEWPc/Yi03UhSX1W7fdVSqBmCF1P5G9AtbJIDW2myI5
	 +AV7lpM4HpskJyPcCAOW/W7OXA3cma3BS912y+221v9c0BkiBSpTo6mI4Luw/Evsw1mDR
	 7I2kgv7g10NtQWVo7FTPa+EZT6Ivo/NJdtVmS/bSJwVwkFU7wYitIFDYTw6/+RJl1xftA
	 fslqs3XwNrAfeg1j44Zg/tM4r+uSr/4Rwj5afH7BhLBrVBE3+SqntfxvynvCdtmcpPSwX
	 lBbQmIApyaFPIM/+/AkvZj/6YE2n9MMdc8XHgSQ7yfO1nP0DJNQbMUH4fJvpC7hnfpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gZo7m0cA5ndQNqGEloKfhBGbo4xZo4mw9z16qS2RrPo=;
	b=SVLQnJRTrGflmszl8rtQCq+yLESHunNokLkSm4vj68Lb/6Ko+260hvvymfg8By3mte41
	 OLgRdgcFYfVoZ+mSdAyMsyL/9TVEKE0mqmqwTOhtbAoxcIW6pS/mk9SPHbWPmXuSytxcD
	 X/Lb6qsFmSDRRTtW20DkaBsNyow49nJgsKQ03fak7ykxU6999e43StqRIm2GkLqH3ijoQ
	 AwjBFjduhmre4aHBNmugLtTDbqDHoQ7enLhA1lzuttfldTXW7FwiYF+WLNVijfwkasA/z
	 pbXQqcbAJbY6NGRPDAuPtcUQeUeeaaonIFLPSn3onBuaHpk0AmE/SyqS+n0BYzswwlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqB+trWt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A0B606AB0A;
	Wed,  4 Nov 2026 22:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xqB+trWt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A151F0093A;
	Wed,  4 Nov 2026 22:32:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831571;
	bh=gZo7m0cA5ndQNqGEloKfhBGbo4xZo4mw9z16qS2RrPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xqB+trWt9iVbDRLdUl114K9PNvftjQ5V14n+dLJW0l19KjCe+S7YafdZ1x98BxqcE
	 7Bb47haaMxHJIO03/aKN6ZjVDaakg2eDm7e3ZX7OZlcihphhAeRLNxj/T20k0wo8ei
	 h1mfq0CzEU1/4DfPYMjuupOoWPgAMEpWxXfs49d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 0783/1005] xfs: fix unnecessary dapos truncation in xchk_dir_walk
Date: Wed,  4 Nov 2026 16:08:36 -0500
Message-ID: <20261104211105.289155555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Darrick J. Wong <djwong@kernel.org>

commit f60a2ef8d8a7ac6dedf4d0c3325cc3fc2fe0d948 upstream.

LOLLM points out that the all the implementations of xchk_dirent_fn can
handle a signed @dapos parameter, so the truncation here breaks the
information captured in scrub tracepoints if the directory is very
large.  I don't think it ever made sense to do the truncation for the
VFS readdir code for programs that can handle 64-bit offsets, but commit
15440319767942 has been around for 17 years without complaints so I'll
leave that alone.

Stumbled-over: 15440319767942 ("[XFS] truncate readdir offsets to signed 32 bit values")
Cc: stable@vger.kernel.org # v6.4
Fixes: 4c233b5c4f29df ("xfs: streamline the directory iteration code for scrub")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/readdir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/xfs/scrub/readdir.c
+++ b/fs/xfs/scrub/readdir.c
@@ -238,7 +238,7 @@ xchk_dir_walk_leaf(
 		dep = bp->b_addr + offset;
 		length = xfs_dir2_data_entsize(mp, dep->namelen);
 
-		dapos = xfs_dir2_byte_to_dataptr(curoff) & 0x7fffffff;
+		dapos = xfs_dir2_byte_to_dataptr(curoff);
 		ino = be64_to_cpu(dep->inumber);
 		name.name = dep->name;
 		name.len = dep->namelen;


