Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626168;
	b=nn+1MjfP5y/88lGGtUYoN9TNvvlGsrnMCi9DdQOVuYUyHdVeMVGhkFVwb5ELTEPDZxLT
	 9+MBS2vFP9L9GMaED6vvFugV9kj5HRNndUSzStfuTKhICgFL/Ad5HeZnXRo3lB1wUeQm2
	 hsHS+TvN/m3nFhF4VIPDVo6QBuFsawOk28exhOizah2innAwS00uziYjjgPQ7wurYU/CB
	 47qEHkgSHRhIRVZOzauh6lMk4cAdy53rh6JLOBgCWSNFfTOblgf1aLGJaMxvYwOFj37Sx
	 Zr3AWFsBau+kyOmz7oicl9M8wz+TCHt1HnbAroBsunoUMzU/66Uvg4P0AAcWvBietNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626168;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dUn7xT3iOGhvf8Hv7EcOsTbI34DYF9R4PU2ByYTlCv8=;
	b=KMCmZ2tNkL1+qbPCv4R6ElJZ6BeHI3NZ6YCsxWD4vRYc8x+bIGmgn0ekLGs/vlP2ICiq
	 04FC2yxw1KGKvSYP2x352WdM/FvEowAY3JLKTjZluPawMq2UzXITz7eVC3qrgVyVLPvGb
	 fH1hSQGAj+REVtlGbj+2uQAzlBorVj86s6pcRMFyNM6jz5RbvBSiWLBH2kvJgvAXZvwii
	 M86y4eKox2SVYgjWkrv1AZMlrJ7TwZwN/Lr4FdB1idWe61xOsjhrnffVXeFPHfoYVXvFg
	 a7+IYKmBPaS1sgBNtH2d7xLSzklprdBDv/XknpkXp+dnDVbNwsp1zFEoT4FUWdxHq1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NuoURnQN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7CB606A323;
	Wed, 25 Nov 2026 17:02:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NuoURnQN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F73E1F000C4;
	Wed, 25 Nov 2026 17:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626168;
	bh=dUn7xT3iOGhvf8Hv7EcOsTbI34DYF9R4PU2ByYTlCv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NuoURnQNNdmOtKkGdzgZQTkJE+ZFQ7Xs9o6+2S6nFhphqRtazKISGuEmucFItIHrS
	 tSn7ra+23tx8QPGkIuv1k80P6nT5+hlsNJ3q/nbL36IJg5n1yVnulhW8IHnEp+qo9B
	 uGI1M/45bzKpkMd8Rbx9ipI4AEANDuNtCOiBeF14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 710/816] dm-cache: fix ending a cursor that never began
Date: Wed, 25 Nov 2026 15:37:38 +0100
Message-ID: <20261125143905.611862110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 421420758be348cb90715bfaa26e1211a12ff1d0 upstream.

If dm_bitset_cursor_begin fails, dm_array_cursor_end(&cmd->hint_cursor)
is called. However, cmd->hint_cursor was only initialized if the variable
hints_valid is true. Thus, we must also destroy hint_cursor only if
hints_valid is true.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Fixes: 629d0a8a1a10 ("dm cache metadata: add "metadata2" feature")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-cache-metadata.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1442,7 +1442,8 @@ static int __load_mappings(struct dm_cac
 					   from_cblock(cmd->cache_blocks),
 					   &cmd->dirty_cursor);
 		if (r) {
-			dm_array_cursor_end(&cmd->hint_cursor);
+			if (hints_valid)
+				dm_array_cursor_end(&cmd->hint_cursor);
 			dm_array_cursor_end(&cmd->mapping_cursor);
 			return r;
 		}


