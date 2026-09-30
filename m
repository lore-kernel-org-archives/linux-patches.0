Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D91437CD22;
	Wed, 30 Sep 2026 16:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786187; cv=none; b=mHb5/LHGQnF+szo0XP1uz59PtnDrskxv3IfCM3u1fOmvSQiUZlLpEl/vyR33Pxu8mVlmiPSdsN5idMR7VdbkNQhQsRQB4t7TPD+Xk239vsrT9cOVSNM3a2DLuDqljJsAdliZ1Nx7Siy5qouwaduQVaKEQlarEuku2SeBNpyBGhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786187; c=relaxed/simple;
	bh=S1rXku8IFcQpaTHhk039x1W7EchLijslx16IaqKV2gA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SQUlPs2njwBb/l0hB9qO2k6uV/DtDtkzna34j6o2eJabCiC6IDnEx5PEZoVFC6f4z5PZaz4BUNhcKx7XvK9+33K4ehho1EDJpu58yn4ew4opOZBciiF5D8s6fLmWYrwjKYk4lMNc9AAfqRcsGarn3RQ/dJRHx9MCK8sTpJa2ALg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ubFiP6Vg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ubFiP6Vg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A771F1F000FF;
	Wed, 30 Sep 2026 16:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786186;
	bh=jLxCjUcHlminaRxvo/s6mvMUwOV0/cV89qQjqpPmXU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ubFiP6VgS3yNTQ46y/ZF4XCh4rKv6ZoVIuAi8lDfq/iVYgCF+mLvpPlIXuFh3IrRl
	 zYEvabwIyiwFgvnRaeaRS2P19pIcl9IQTfxsE0DZJZo2Bth3y9ClsLHHsk1D9xpfrJ
	 YnJ4GyImf8gRAA8pSiWXwGiRkrfprio+IgHO3Ess=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sajal Gupta <sajal2005gupta@gmail.com>,
	Ruben Wauters <rubenru09@aol.com>
Subject: [PATCH 6.1 772/982] drm/gud: fix out-of-bounds write in gud_plane_atomic_check()
Date: Wed, 30 Sep 2026 17:25:08 +0200
Message-ID: <20260930152433.335668459@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -547,8 +547,8 @@ int gud_pipe_check(struct drm_simple_dis
 			goto out;
 		}
 
-		req->properties[num_properties + i].prop = cpu_to_le16(prop);
-		req->properties[num_properties + i].val = cpu_to_le64(val);
+		req->properties[num_properties].prop = cpu_to_le16(prop);
+		req->properties[num_properties].val = cpu_to_le64(val);
 		num_properties++;
 	}
 


