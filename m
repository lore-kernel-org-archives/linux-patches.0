Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5339025E813;
	Tue, 11 Mar 2025 15:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705617; cv=none; b=ZZ+WsNwWrLUqjOBQ0SttOlqSN/6CeO+vQ4XTJxILRrJeJidLUraM0fjL/5JSqx3HAZu02uFeY1YE7ZYFFtHsaAzw3lTUBE+eu0HGrwNjTyGI83QwiwZrrwoHwhFk+CSfGHgdvFWT4yUX891oWVrM5PkwTUMvRgZC9iMTcngn/cM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705617; c=relaxed/simple;
	bh=+C9X2oICjDZuyPn0Q73g72OKDFOXBma6IYdfekEXkPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nmMDk5XnMEF0Ws3qvpIRxdbOBtKbNmsi9sKyOUV9dXBFlnb9j4uMFXUJEzbg+KH14cQdLf9n7Cp1iMdXxRyKwKEuji+d5o9STHYQOQ0ZOH7u3OOlZYTfNity40iMrROiBvmUC1NqcUiX9cnmu6bEanTw1tmg1CeOfZCe1hbDEFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zWon4tUn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zWon4tUn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D012AC4CEEC;
	Tue, 11 Mar 2025 15:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705617;
	bh=+C9X2oICjDZuyPn0Q73g72OKDFOXBma6IYdfekEXkPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zWon4tUnWySKHxpRYxGIAh6lHi/h3K6VOr/hJeWgOeMmdkNq1Uu2iDCkg6EB2pTHX
	 F6faB9goLtWhHRB80Am6hDqVbjyl/NkkrPHY6mMPgqLsnF8fASkFyHexctmSPg4OmD
	 U7gF0sqorvvphqZfEwinproQIW2cKZtNvtz3xxBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jos Wang <joswang@lenovo.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 5.4 078/328] usb: typec: tcpm: set SRC_SEND_CAPABILITIES timeout to PD_T_SENDER_RESPONSE
Date: Tue, 11 Mar 2025 15:57:28 +0100
Message-ID: <20250311145717.988635526@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3035,7 +3035,7 @@ static void run_state_machine(struct tcp
 			port->caps_count = 0;
 			port->pd_capable = true;
 			tcpm_set_state_cond(port, SRC_SEND_CAPABILITIES_TIMEOUT,
-					    PD_T_SEND_SOURCE_CAP);
+					    PD_T_SENDER_RESPONSE);
 		}
 		break;
 	case SRC_SEND_CAPABILITIES_TIMEOUT:


