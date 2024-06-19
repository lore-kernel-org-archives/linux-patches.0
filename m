Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE3FA1494A9;
	Wed, 19 Jun 2024 13:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802898; cv=none; b=Pe74wtqijzzZ3lkfnXW9DDNuwANWzfJ9ijm0vxD4kCEjgn30sKW7jTOZo52mtjeXQPufNflU4iYg4wG1/AalcQUDoahu4bSsPcoEw1LIv4nGuLaxBN+JW4UjJDI2KwVmKskrnAPAsPsx5RTZnX6EISRgqqvkA/azaZ/CDBm15dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802898; c=relaxed/simple;
	bh=0uWX1OlRYIhFGWZY7tI56uZg0Uqe/BKYypzUZxOfWkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2pFNkIHGrRpDHsYJ/lDh/rqO/4Ldqn92BhB8YlYlSGcDm6HDeCd01u0MQOzy1aSjYtl6rA2yR+YT8RKM0zeUCGRQqVK/BmZwBncHoA/rpJ4MX+TgNOVMY0qemYjWRuZGLz+4nfQ0wQMZAdpOH8/YeFhbn4/3ax34llhae3eU3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Othd4Ehd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Othd4Ehd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A2EC2BBFC;
	Wed, 19 Jun 2024 13:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802898;
	bh=0uWX1OlRYIhFGWZY7tI56uZg0Uqe/BKYypzUZxOfWkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Othd4EhdMRRr3fd/gSwsmXINHuT+efttXcLn1DJ9j6hEWo2RTlbwwbQxSXYpRCzVW
	 i7/PQCunJixKjzSkV6nRJAFxZ6Ufn9iS/RhzpIF1/vTo8cdXpWaJidyfTmjRTR2u5j
	 IRtAzOlGpj72IHpqkvthLwrlUAlZPqfKHeSsIhZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Sunil Dhamne <amitsd@google.com>,
	Ondrej Jirman <megi@xff.cz>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: [PATCH 6.9 085/281] usb: typec: tcpm: fix use-after-free case in tcpm_register_source_caps
Date: Wed, 19 Jun 2024 14:54:04 +0200
Message-ID: <20240619125613.115396003@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3014,8 +3014,10 @@ static int tcpm_register_source_caps(str
 	memcpy(caps.pdo, port->source_caps, sizeof(u32) * port->nr_source_caps);
 	caps.role = TYPEC_SOURCE;
 
-	if (cap)
+	if (cap) {
 		usb_power_delivery_unregister_capabilities(cap);
+		port->partner_source_caps = NULL;
+	}
 
 	cap = usb_power_delivery_register_capabilities(port->partner_pd, &caps);
 	if (IS_ERR(cap))


