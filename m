Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10615268C73;
	Tue, 12 Aug 2025 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020316; cv=none; b=CotW1EUZNM/YSPbESIapYWuHZr+OyVAJB6tdgxKwCONCMzJgKvD9XSA8KUywVIKUSwCq2xmAFscGg8Aqju1oWYmC3TR/MJxhOl7YirkJeZwRhusw4nhF60U0oGx0eONLmsNjXBd5+JYqWNm+H4lFq2cGbcTvOcZbriCpCmd5JBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020316; c=relaxed/simple;
	bh=YsmeIY4Zk7wH65b31WwKDrPR20uOkBuL4d0fZJ9hwSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZGJXSsxXpAa7YK6N9cjB50jByi/aAyvQrLXAK4lD4yRGhU8uETNr6kTeOHYIgBhGV+3SUIsp7oiBVPGIwZgu84Ulo+5iLXa3HyQsrN/iF/wjjh3diBgfvGB9BQ9VFOuE/CF2LDxwb380qnf6acoOZpxVNIfpvL5nMkYELWWK/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J1LUMSoS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J1LUMSoS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4216CC4CEF0;
	Tue, 12 Aug 2025 17:38:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020315;
	bh=YsmeIY4Zk7wH65b31WwKDrPR20uOkBuL4d0fZJ9hwSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J1LUMSoSJ1+xtkYyPDZPoXP74B7Hx0k9JKEMZjLELU3uDiXHJsotngLdwcwS9ok5U
	 g/BvEWDh92OCLfieT2geOcKUmf5GWbAhiiQ2Y8joMMt1G/GrjsneebZd2/zFO9kdU5
	 cAho/YeAJv5trcF/mJWAg0YceAujZfXif1Z6SI9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/253] usb: typec: tcpm: allow to use sink in accessory mode
Date: Tue, 12 Aug 2025 19:27:12 +0200
Message-ID: <20250812172950.612259432@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

commit 64843d0ba96d3eae297025562111d57585273366 upstream.

Since the function tcpm_acc_attach is not setting the data and role for
for the sink case we extend it to check for it first.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20250404-ml-topic-tcpm-v1-1-b99f44badce8@pengutronix.de
Stable-dep-of: bec15191d523 ("usb: typec: tcpm: apply vbus before data bringup in tcpm_src_attach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3866,12 +3866,17 @@ static void tcpm_snk_detach(struct tcpm_
 static int tcpm_acc_attach(struct tcpm_port *port)
 {
 	int ret;
+	enum typec_role role;
+	enum typec_data_role data;
 
 	if (port->attached)
 		return 0;
 
-	ret = tcpm_set_roles(port, true, TYPEC_SOURCE,
-			     tcpm_data_role_for_source(port));
+	role = tcpm_port_is_sink(port) ? TYPEC_SINK : TYPEC_SOURCE;
+	data = tcpm_port_is_sink(port) ? tcpm_data_role_for_sink(port)
+				       : tcpm_data_role_for_source(port);
+
+	ret = tcpm_set_roles(port, true, role, data);
 	if (ret < 0)
 		return ret;
 


