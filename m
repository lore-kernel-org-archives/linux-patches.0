Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10E476044;
	Mon, 15 Apr 2024 14:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191522; cv=none; b=ZskM1zH5U+oILt6GeUNl5USZMuDFnvryjvdLTX2ZgJ4pWB3QcaPgPVdjPFvWErmjqYnCsCSf8KCagpJrq8KTdrsKveZNNEDJJaFS4F171bOSIpZX7ozb63xzZsNNu6h+ZwX84oHZ1QiYk0GTFzAZguN+mLdDKCoGJnd55vPEyts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191522; c=relaxed/simple;
	bh=GcmNkapGJZXE+g05G8F2nJa0V6TMC1XGq9mQttTL/lU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RIpqju9j+WlJrZpKCC14ru9Kc9YtEWYuBNlDWU63cdAyFoJHWS2FKFn8+GvTnDVX5846s8QRXTxSefnYQzQE8ctACCYUYcpNx0IwuhTEj2WrNE9WUADzKTXYCKYh9Nj01EgmcWF482zvk6xrxY8VTyjfyglg0q97i3yBBFOsLKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YeaapeK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YeaapeK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 680B1C113CC;
	Mon, 15 Apr 2024 14:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191521;
	bh=GcmNkapGJZXE+g05G8F2nJa0V6TMC1XGq9mQttTL/lU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YeaapeK9OkTUCfqx9Z/hGQXAEOxv4yGicmSgnhu0zt+VSILlN8UTVEKhjhgBZhuN5
	 bpTxu2VhK/+R7vBDLMUljXTqgPj2c1AzkECAh2EYupo9JPRkSjM+FY4Su3YMTZg3lh
	 U0m3tJTZgbauc17BXCRZxVvGbUTXQbF7KxBRtGiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alvin Lee <alvin.lee2@amd.com>,
	Hamza Mahfooz <hamza.mahfooz@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.8 169/172] drm/amd/display: Do not recursively call manual trigger programming
Date: Mon, 15 Apr 2024 16:21:08 +0200
Message-ID: <20240415142005.480053672@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>
References: <20240415141959.976094777@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dillon Varone <dillon.varone@amd.com>

commit 953927587f37b731abdeabe46ad44a3b3ec67a52 upstream.

[WHY&HOW]
We should not be recursively calling the manual trigger programming function when
FAMS is not in use.

Cc: stable@vger.kernel.org
Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Dillon Varone <dillon.varone@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/optc/dcn32/dcn32_optc.c
@@ -267,9 +267,6 @@ static void optc32_setup_manual_trigger(
 				OTG_V_TOTAL_MAX_SEL, 1,
 				OTG_FORCE_LOCK_ON_EVENT, 0,
 				OTG_SET_V_TOTAL_MIN_MASK, (1 << 1)); /* TRIGA */
-
-		// Setup manual flow control for EOF via TRIG_A
-		optc->funcs->setup_manual_trigger(optc);
 	}
 }
 


