Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665991DF749;
	Tue, 11 Mar 2025 15:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706652; cv=none; b=dRMh+StHD2m6Nq+/eBR9wy5yUn8QpQYLtSyR8c02obGWfZzAL9qqN2Sa1xHjhQkwc5P1RGmrFv6yDccxSuVidtJBi82UezvV/+ntdD/kCqmeiYHmHJWmG0DuLJd2XbTrs9unarLAlXjFGlX38E/jvM+sP/G2Ujpik/+HDC8hjUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706652; c=relaxed/simple;
	bh=3G1IBmgziWBcOqZN4X4UOK/ysts+o1nDh+9O9VPln80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YX3jWSNSlFNaohjyDWS2xW57ioxh141dReMx6183223i+9AZhqy/eVUGbSMPfCpk0Gin9p2VaemdWqh9B2QL/nOcHy5od9Gif2jIP5j+MsQWeooCT7x5ris+Vio9i7zJ1lu5WbsbCul2Scm2J/Teh3bEnNeXMJz8OxHTRhpYF0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uhw1+U/T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uhw1+U/T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39EEC4CEE9;
	Tue, 11 Mar 2025 15:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706652;
	bh=3G1IBmgziWBcOqZN4X4UOK/ysts+o1nDh+9O9VPln80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uhw1+U/TiIs4bCAU88qSSKXbbzih2WKWG7ih3x5cp+PKflIslfg10F25vxruyxkV9
	 X06M9lUVn9n8uIayD+2QwX6m9CUdjojGlCyBuAz1dDJDkw+WRJguGlmBYfiaNPhkoc
	 +rdvDism7WXCLVSFMgGz4Q4cpbzilEUVnTIDDrxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 5.10 121/462] usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE
Date: Tue, 11 Mar 2025 15:56:27 +0100
Message-ID: <20250311145803.139316893@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jos Wang <joswang@lenovo.com>

commit 2eb3da037c2c20fa30bc502bc092479b2a1aaae2 upstream.

As PD2.0 spec ("8.3.3.2.3 PE_SRC_Send_Capabilities state"), after the
Source receives the GoodCRC Message from the Sink in response to the
Source_Capabilities message, it should start the SenderResponseTimer,
after the timer times out, the state machine transitions to the
HARD_RESET state.

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable@vger.kernel.org
Signed-off-by: Jos Wang <joswang@lenovo.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://lore.kernel.org/r/20250105135245.7493-1-joswang1221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -3195,7 +3195,7 @@ static void run_state_machine(struct tcp
 			port->caps_count = 0;
 			port->pd_capable = true;
 			tcpm_set_state_cond(port, SRC_SEND_CAPABILITIES_TIMEOUT,
-					    PD_T_SEND_SOURCE_CAP);
+					    PD_T_SENDER_RESPONSE);
 		}
 		break;
 	case SRC_SEND_CAPABILITIES_TIMEOUT:


