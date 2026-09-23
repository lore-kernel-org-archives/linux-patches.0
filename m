Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA6F34756D2;
	Wed, 23 Sep 2026 14:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173995; cv=none; b=mz9ySBHdNPDhUxMQtssi2UwwM5c1pfsWay7tuVtUlQMAgd3JMO8ygxp49dBSELHqBGprw+q6ljpMcpK0c+UwwmCK63tp/NjlCuJZ4DK/mYooWpo2qu4U6xyUaFfgZokDZ1aIMvIcfQMlIACyRvurMhRVYItA1yTzI7PGA5XA0cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173995; c=relaxed/simple;
	bh=ipMgeqgmGnmZx6aqUmd1oy/0TBFMd00FfHe7Tui7G3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MBjF2ELD7+PicG3EX5+ZwFR7SwBDyimFavMdqzmK6fpj+ZOYuEjNE6xNMc6BnOHToCV5y3q/EX96xdcQTwWEjoqxUHX5R/I/NU7/c1HkuaM7Xn271/ArrDjXTku/1l+cldpS3YFE27dAfqRuPORWGM4y/V13ns5rh744//3f1Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQsFm9sm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQsFm9sm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11FDB1F000FF;
	Wed, 23 Sep 2026 14:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173994;
	bh=PIaKP/lpq9pLFOiupV3yc7IuG7hAXVcs+URQG0DIOV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQsFm9smXWikdDrdWSBNR63hvaNdgWKWJSMffZblwdv+xDuO0ghQ3zOEA4mU7aEkZ
	 JhQ/PECIkFc6g4zzVqvm2yv8jI/gK9PH1P6UAQi41IvQbokiBLSNe8bLNy4Jy8nQSY
	 pp/a/Df07FkP/suza1D/uQnTQ4n++5d4on35hsHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 7.2 400/438] drm/gud: fix out-of-bounds write in gud_plane_atomic_check()
Date: Wed, 23 Sep 2026 16:07:01 +0200
Message-ID: <20260923140655.260795732@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sajal Gupta <sajal2005gupta@gmail.com>

commit 59ced288fcba9e91bd38e61a972ad782c4edb7d0 upstream.

The plane property loop uses req->properties[num_properties + i] as write
index while simultaneously incrementing `num_properties` inside the loop.
At iteration i, num_properties has also incremented by i, so the write
is done at `initial_num_properties + 2*i`, skipping every other index and
advancing by 2 per iteration.

With just 2 connector and 32 plane properties the last write happens at
index 64, one slot past the end of the 64-slot (indices 0–63)
allocation. A USB device can trigger OOB by advertising the maximum
number of properties.

Fix by dropping the redundant `+ i`; num_properties is already the correct
running index, as gud_connector_fill_properties() fills the preceding
slots.

Fixes: 40e1a70b4aed ("drm: Add GUD USB Display driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260821071812.16500-1-sajal2005gupta%40gmail.com?part=1
Signed-off-by: Sajal Gupta <sajal2005gupta@gmail.com>
Cc: <stable@vger.kernel.org>
Acked-by: Ruben Wauters <rubenru09@aol.com>
Signed-off-by: Ruben Wauters <rubenru09@aol.com>
Link: https://patch.msgid.link/20260902123254.36987-1-sajal2005gupta@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gud/gud_pipe.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/gud/gud_pipe.c
+++ b/drivers/gpu/drm/gud/gud_pipe.c
@@ -562,8 +562,8 @@ int gud_plane_atomic_check(struct drm_pl
 			goto out;
 		}
 
-		req->properties[num_properties + i].prop = cpu_to_le16(prop);
-		req->properties[num_properties + i].val = cpu_to_le64(val);
+		req->properties[num_properties].prop = cpu_to_le16(prop);
+		req->properties[num_properties].val = cpu_to_le64(val);
 		num_properties++;
 	}
 


