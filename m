Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217369;
	b=pocv+EHjduEcYTGjYjx2EkKIRMFxfn6/iXJTYY8xOcbDkksK95PtW4CLhrbLp79UyJPH
	 oEOJjqG1Aq3cuz7O3XYdTzpgIJpsD1TD9LyGASH2d1KNpKDFDTke5J9Qm2XltoWoPMioz
	 C2vjPfk5eoeNcGWy9PQ/IijIebHMytAIa3MsbC96REz2A9DkdZB8ThzTJeF5EE4bzcP/N
	 NCpGgyXkpRugnHsCBMihz3UxEgaksurgn7GY67swJzy/VnSuTulwjRWIGQkimRZOBc3Ek
	 H2WZQvNhrpKi+UiqyyROysBAwum4aF0/x/YUJ2jp0vZQq8lzbjnd+tSxHF3220xUo6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217369;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aDkUpcR2pLvm9uABGakLco3rMbSPHUu1tkEAmM1goBo=;
	b=zZfSoLdctzIcRSPrnjcgZdFFYGBh4eqW9y7SnSXz1dFohgcNj2fW+AIbb/Yp235PF81r
	 nc7KpmIDI3BPsiJcLO1E3NVgR9eOX0Q7oX5gLtHEdptFjBJNCGyhAOC+ny+3wQabyZBFC
	 Ec56D1n1880PqQgDZJ9o+2zcJcPODS7/sltZjqHOBdhB8ieXhgmzPsTOHli73Uc7ut5D6
	 mfhR/wighSt6M2yhGdsqlL3bh4x3aZt1PqArfphrFEq94gFOMahUBDOpSJx9Ic1BsYpFD
	 IL9z5/NrENtnkzo5XeQItkO0oPzqY+bPkfxugQXCxpj+ytn/QdvEBiIAnlMidfx+wiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqbjQ3G9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D93606A31C;
	Wed, 28 Oct 2026 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gqbjQ3G9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B05331F01825;
	Wed, 28 Oct 2026 19:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217369;
	bh=aDkUpcR2pLvm9uABGakLco3rMbSPHUu1tkEAmM1goBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gqbjQ3G9z/uDvKlOvmQzuKC2UToDBQxy2IlKQfGx/+jmaVjqapFzzwGU+QU5juHEl
	 JMybyLCbTrtMfxZrRNaVI+5UA9zQu7JEH6C8y4C9k2ki3GRX3gDv5g8ttbQNNaVJUb
	 x0eJdOWpR1JMNL0VuzO47j+WFUmF2KDOYrd/TjtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1836/1887] firmware: arm_scmi: Avoid IDR updates while cleaning channels
Date: Wed, 28 Oct 2026 18:05:32 +0100
Message-ID: <20261028170541.228558729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sudeep Holla <sudeep.holla@kernel.org>

[ Upstream commit c38b1e19485aaa820e52cfe162525a8af67563da ]

scmi_cleanup_channels() walks the TX/RX channel IDRs with
idr_for_each() to free transport resources and destroy the dedicated
transport devices before calling idr_destroy().

The destroy callback removed each entry from the same IDR being walked.
That is not needed for this cleanup path, and it is unsafe because
idr_for_each() has not advanced its radix-tree iterator while the
callback is running. Removing the current entry from the callback can
invalidate the iterator state. The callback also cannot be protected by
rcu_read_lock(), because scmi_device_destroy() may sleep.

Leave IDR teardown to the following idr_destroy() call and keep the
callback limited to device destruction.

Fixes: 05a2801d8b90 ("firmware: arm_scmi: Use dedicated devices to initialize channels")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20260714-scmi_core_fixes-v6-6-3afe499d46e3@kernel.org
Signed-off-by: Sudeep Holla <sudeep.holla@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/driver.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/arm_scmi/driver.c b/drivers/firmware/arm_scmi/driver.c
index ed32f48c8fe3b..2a814d3c4ca28 100644
--- a/drivers/firmware/arm_scmi/driver.c
+++ b/drivers/firmware/arm_scmi/driver.c
@@ -2210,7 +2210,7 @@ static int scmi_channels_setup(struct scmi_info *info)
 	return 0;
 }
 
-static int scmi_chan_destroy(int id, void *p, void *idr)
+static int scmi_chan_destroy(int id, void *p, void *data)
 {
 	struct scmi_chan_info *cinfo = p;
 
@@ -2223,8 +2223,6 @@ static int scmi_chan_destroy(int id, void *p, void *idr)
 		cinfo->dev = NULL;
 	}
 
-	idr_remove(idr, id);
-
 	return 0;
 }
 
-- 
2.53.0



