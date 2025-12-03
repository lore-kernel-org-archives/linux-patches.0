Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744D631328E;
	Wed,  3 Dec 2025 15:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776741; cv=none; b=sta9ca/Px+Df/M3XRyU0pEN/sbxfc/1VRIQEJvLV3tsxrjBDQXipYHgmETrl5nAXjfpucZrqfoh0sd5NMEevu5zzxe5Jv0gI/yQx6MAK8EagaZY7Xrf2VXL4ayxe9Evl17j6CFv4+3q4AqLSLhN8FEuhSf7mzMkMmQ88lN/EIw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776741; c=relaxed/simple;
	bh=Kyr+TQyb4Bdf72YPxiPRcz0g23djHJ0oVYNBaa0DTls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0rSW9iK5L01uwJyLn9vYq62S3y8omRsBf8qXwqgNIS3Cu/FXY/H5WW7AExrnXZgEsxKDRqVqA3s8Jo8tk53FLR2MKTtc804qsfkEwvjQ7uLHeAiuDJ1DOQlu+8UbQLecaT6kfua72dPkTKiOHWvhS54S5M0NTf6rZi2p133FF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEqYTlNi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEqYTlNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B270AC4CEF5;
	Wed,  3 Dec 2025 15:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776741;
	bh=Kyr+TQyb4Bdf72YPxiPRcz0g23djHJ0oVYNBaa0DTls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEqYTlNi0+VqXirEXq+H9j6EnFhbRsDOkMfvAIloh+3MYTjUUctSPiWs3vYUJBMJN
	 pKPttUDTYydzSGBFCJ3RKFDb51TFDsv9FV9JihiaRaDc73c/aHKtDhqh+Ve7LmiJBv
	 ISz2Dh+cwd/52RvGrPSiwIemMfxOGyTGyHub/C0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 272/300] dm-verity: fix unreliable memory allocation
Date: Wed,  3 Dec 2025 16:27:56 +0100
Message-ID: <20251203152410.709121085@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit fe680d8c747f4e676ac835c8c7fb0f287cd98758 upstream.

GFP_NOWAIT allocation may fail anytime. It needs to be changed to
GFP_NOIO. There's no need to handle an error because mempool_alloc with
GFP_NOIO can't fail.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Reviewed-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -314,11 +314,7 @@ static int fec_alloc_bufs(struct dm_veri
 		if (fio->bufs[n])
 			continue;
 
-		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOWAIT);
-		if (unlikely(!fio->bufs[n])) {
-			DMERR("failed to allocate FEC buffer");
-			return -ENOMEM;
-		}
+		fio->bufs[n] = mempool_alloc(&v->fec->prealloc_pool, GFP_NOIO);
 	}
 
 	/* try to allocate the maximum number of buffers */


