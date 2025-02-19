Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC9A1D6DB1;
	Wed, 19 Feb 2025 08:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954210; cv=none; b=jl87NcdsmTrgyOxW9KY651Wx7SO+zHbsNi9Af6BSXLDpGQ/ZRuYnK3U5Km88NwXajG3YY97YYMWoLuIw/phfna7/9eat4DLZNRsw7evxSqQfsYiZdBvekr2fO1wPhq+N3gr13vOlt0UxrvRlpSgFk7d/ko/rDHRCJewxZ7mmMGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954210; c=relaxed/simple;
	bh=sITgN7jkpWPBQr/9K9OF+e2fI+cSTneHQU9o9yGa92U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OKAIkXK+Ebu0YEgQaRLojKCzRVWgfF7SiwQLTa3+BnNz9baeuAq6M21JOclKmYwQxuTDpHc8UVn30+hLS1tfh7bBj+LJQF6hLgyHxwOqNxzda8epP/LL9QZHvIlVa0op0pO7rIyB5fxtOly1hlP9QjzAq5oFuZD8eBcbh4BaeDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=miJkQIO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="miJkQIO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B203C4CED1;
	Wed, 19 Feb 2025 08:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954210;
	bh=sITgN7jkpWPBQr/9K9OF+e2fI+cSTneHQU9o9yGa92U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=miJkQIO6GuMDI7d1UXQUuZ1T7dmndRmLw8Qdu3DIFzKc24fXuKOUCxF5rNUFfMrq7
	 vDDaO+VgTQsmnBF5yo/GTKSy8Xf6K0hIerYPjOw32k1Ll33iM0TjEnm6A9Il0f4Lpg
	 8FbTEBSJ/ae3NpMCQ2Btv4dkZsQZgepEvAUVxx9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jos Wang <joswang@lenovo.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Amit Sunil Dhamne <amitsd@google.com>
Subject: [PATCH 6.13 131/274] usb: typec: tcpm: PSSourceOffTimer timeout in PR_Swap enters ERROR_RECOVERY
Date: Wed, 19 Feb 2025 09:26:25 +0100
Message-ID: <20250219082614.736182451@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jos Wang <joswang@lenovo.com>

commit 659f5d55feb75782bd46cf130da3c1f240afe9ba upstream.

As PD2.0 spec ("6.5.6.2 PSSourceOffTimer")，the PSSourceOffTimer is
used by the Policy Engine in Dual-Role Power device that is currently
acting as a Sink to timeout on a PS_RDY Message during a Power Role
Swap sequence. This condition leads to a Hard Reset for USB Type-A and
Type-B Plugs and Error Recovery for Type-C plugs and return to USB
Default Operation.

Therefore, after PSSourceOffTimer timeout, the tcpm state machine should
switch from PR_SWAP_SNK_SRC_SINK_OFF to ERROR_RECOVERY. This can also
solve the test items in the USB power delivery compliance test:
TEST.PD.PROT.SNK.12 PR_Swap – PSSourceOffTimer Timeout

[1] https://usb.org/document-library/usb-power-delivery-compliance-test-specification-0/USB_PD3_CTS_Q4_2025_OR.zip

Fixes: f0690a25a140 ("staging: typec: USB Type-C Port Manager (tcpm)")
Cc: stable <stable@kernel.org>
Signed-off-by: Jos Wang <joswang@lenovo.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Amit Sunil Dhamne <amitsd@google.com>
Link: https://lore.kernel.org/r/20250213134921.3798-1-joswang1221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -5541,8 +5541,7 @@ static void run_state_machine(struct tcp
 		tcpm_set_auto_vbus_discharge_threshold(port, TYPEC_PWR_MODE_USB,
 						       port->pps_data.active, 0);
 		tcpm_set_charge(port, false);
-		tcpm_set_state(port, hard_reset_state(port),
-			       port->timings.ps_src_off_time);
+		tcpm_set_state(port, ERROR_RECOVERY, port->timings.ps_src_off_time);
 		break;
 	case PR_SWAP_SNK_SRC_SOURCE_ON:
 		tcpm_enable_auto_vbus_discharge(port, true);


