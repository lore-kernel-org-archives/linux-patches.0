Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398124A32;
	Wed, 30 Jul 2025 09:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868879; cv=none; b=flpg6pl/S2evYuvHRhrwLjhWUD8PWTO8Zc1PvqJvOohNlNonnd+eDrEMKbJ9BEJQeb/XnrNHIuzQUbC13vHlHxDrO9znnn7eeJILVkJUYKevNcEfMSL5WNTsRIcUHHjcD+3aRHyN3RbI/9oDe6mRYhMnEtxuFm2cM0yw/bAhIfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868879; c=relaxed/simple;
	bh=k6WUMwnICMMA8s2JgQbNEkwk0FVf3xWK5PF2Be7XmOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RjXlA9VYpar+nALIsX3s6q2crdC4JgYzMaadFeqBOuR7UTmW4WkQ7qMKo234s6mpH28QF7j0XSfCuQ3tg9zU6csfgvqQrFGRFyDdrXVR3oKRXLF+RrCR8zvTUwBxEd3Ly4tS9zqL969w6UbRGyyEzMrEApXbyIZOhJ/PF6QOh6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SLa1xiMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SLa1xiMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2221DC4CEF5;
	Wed, 30 Jul 2025 09:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868878;
	bh=k6WUMwnICMMA8s2JgQbNEkwk0FVf3xWK5PF2Be7XmOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SLa1xiMltb8ia9ASs2/tbrdEvb7rVofrK2hsSyZIPc+P22WECMUufU9OhHd3Mqyt+
	 2nM+syCmoaNrlef+kowTMDy+JhatYEKbYVXc0OxxvTViHuAPdwUxKocbASkZCflYSs
	 LzeqQ0ZvSp3/8gB+86AsDNWxHgpwbLZFmKT8IC3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/117] usb: typec: tcpm: allow to use sink in accessory mode
Date: Wed, 30 Jul 2025 11:35:38 +0200
Message-ID: <20250730093236.227959687@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4537,12 +4537,17 @@ static void tcpm_snk_detach(struct tcpm_
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
 


