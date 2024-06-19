Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D68143C43;
	Wed, 19 Jun 2024 13:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802222; cv=none; b=QMEkQM88d/ylVRshWZLGykQG6B8qu6w+yvbkOGMujL5uyUOp4riCygN2tLRm13ffV2StIYoOveo+CVry0igHRXe4JOm6OWEsxMZUQLK7jZjH5V+Xtp/6B7i7jhzzf9GLyW1UjbAphnzqcJR+ZHYhu/+mkRaaAFw/g68UWm9R6aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802222; c=relaxed/simple;
	bh=vZPsptq6pb4IPVAJ6TcJm85DZLkNXdFejR5v2dR7xfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dj9vzsLAAuC9DOQ7uDWSEN9n70f5SjY9TVFSHyQH3CV3JV1w4k7GYL9HbFbyZ0T5GzEMkmZBphz8zp8N9auf1LHgOamqCNJGmzduNfZ2RpzkXs5ePyJInFPdhi+dSwOdWnmgyKsOvuI+yV3aCTODEYKh+pTMJrib+rps/wqGHhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsF8hUMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsF8hUMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B54AC2BBFC;
	Wed, 19 Jun 2024 13:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802222;
	bh=vZPsptq6pb4IPVAJ6TcJm85DZLkNXdFejR5v2dR7xfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SsF8hUMbs7TCE4rGzcyWHRx3bQyi4WjQKTO/OUhP1BBvxAI6PtBumzFY/ocQfcrEy
	 1xYhAJCvhSUT90s8H6/TVK0ip0GK9LiBfhQIoAhuYkLFkc3UFXYNd/F9pgg1AIhUnv
	 rY8fvo6OO3l+uuvbD0vOCTCbGO9lAxgvccJOQfJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>,
	Ondrej Jirman <megi@xff.cz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.6 082/267] usb: typec: tcpm: fix use-after-free case in tcpm_register_source_caps
Date: Wed, 19 Jun 2024 14:53:53 +0200
Message-ID: <20240619125609.499503490@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125606.345939659@linuxfoundation.org>
References: <20240619125606.345939659@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amit Sunil Dhamne <amitsd@google.com>

commit e7e921918d905544500ca7a95889f898121ba886 upstream.

There could be a potential use-after-free case in
tcpm_register_source_caps(). This could happen when:
 * new (say invalid) source caps are advertised
 * the existing source caps are unregistered
 * tcpm_register_source_caps() returns with an error as
   usb_power_delivery_register_capabilities() fails

This causes port->partner_source_caps to hold on to the now freed source
caps.

Reset port->partner_source_caps value to NULL after unregistering
existing source caps.

Fixes: 230ecdf71a64 ("usb: typec: tcpm: unregister existing source caps before re-registration")
Cc: stable@vger.kernel.org
Signed-off-by: Amit Sunil Dhamne <amitsd@google.com>
Reviewed-by: Ondrej Jirman <megi@xff.cz>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240514220134.2143181-1-amitsd@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -2436,8 +2436,10 @@ static int tcpm_register_sink_caps(struc
 	memcpy(caps.pdo, port->sink_caps, sizeof(u32) * port->nr_sink_caps);
 	caps.role = TYPEC_SINK;
 
-	if (cap)
+	if (cap) {
 		usb_power_delivery_unregister_capabilities(cap);
+		port->partner_source_caps = NULL;
+	}
 
 	cap = usb_power_delivery_register_capabilities(port->partner_pd, &caps);
 	if (IS_ERR(cap))


