Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980581F7540;
	Tue,  3 Dec 2024 15:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239736; cv=none; b=bCUkWIVdE3umMypih6SG7c2VmP8kr/aXC1lI7LjoyliNPC8Owlw61vV1529PWogX3GAHfMWgG4ppsErdvA2v/egxyFR0zPP9CTXkcdWh0rDnxkMGfNGXin76nIsvabAC0iuc+OcnjzXdIMAxT2OoLRoNK1FQYf+ZnR1lvTC0dkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239736; c=relaxed/simple;
	bh=jKYdN+AnAcZxToffrGRflfs7gDZ9sl0E+eWVnPrDzQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgoU1xiqrmV/3PoW0vg0YoQOciIAd9DzwPpODJPKkyUplCrU7/333Uo0L/+w9BjXbwU1y6k0srdb7V713/DXzHkE+5K1QgkQfS/yessKolsb+yvuPPsWqfKpYc9TAfBqswwGZDYxXuVUPptqNeRI/XWdWuzt38VTP5V1bKeBRtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWqpX0rA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWqpX0rA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3968C4CECF;
	Tue,  3 Dec 2024 15:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239736;
	bh=jKYdN+AnAcZxToffrGRflfs7gDZ9sl0E+eWVnPrDzQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWqpX0rAxfidGLKdham69nS42zfKuZJa+05wdd/RwQraAdHrSP5FxKvYEfI8LnyYW
	 4Ow/u7NRnJ6NcDuKxYh8cxmw12m1NmRTsp2FOzOaYGqYxJ33uySEZ69tTlo4RqYfSG
	 2hdqv6fxpU4YwbtuzkGP/irJKCKl/nlQBpxOTS4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>
Subject: [PATCH 6.11 685/817] wifi: ath12k: fix crash when unbinding
Date: Tue,  3 Dec 2024 15:44:17 +0100
Message-ID: <20241203144022.710117799@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

commit 1304446f67863385dc4c914b6e0194f6664ee764 upstream.

If there is an error during some initialization related to firmware,
the function ath12k_dp_cc_cleanup is called to release resources.
However this is released again when the device is unbinded (ath12k_pci),
and we get:
BUG: kernel NULL pointer dereference, address: 0000000000000020
at RIP: 0010:ath12k_dp_cc_cleanup.part.0+0xb6/0x500 [ath12k]
Call Trace:
ath12k_dp_cc_cleanup
ath12k_dp_free
ath12k_core_deinit
ath12k_pci_remove
...

The issue is always reproducible from a VM because the MSI addressing
initialization is failing.

In order to fix the issue, just set to NULL the released structure in
ath12k_dp_cc_cleanup at the end.

cc: stable@vger.kernel.org
Fixes: d889913205cf ("wifi: ath12k: driver for Qualcomm Wi-Fi 7 devices")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Link: https://patch.msgid.link/20241017181004.199589-2-jtornosm@redhat.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath12k/dp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/ath/ath12k/dp.c
+++ b/drivers/net/wireless/ath/ath12k/dp.c
@@ -1247,6 +1247,7 @@ static void ath12k_dp_cc_cleanup(struct
 	}
 
 	kfree(dp->spt_info);
+	dp->spt_info = NULL;
 }
 
 static void ath12k_dp_reoq_lut_cleanup(struct ath12k_base *ab)


