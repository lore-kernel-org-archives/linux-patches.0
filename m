Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5A91C687;
	Mon,  4 Mar 2024 21:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588128; cv=none; b=c4JKyWVvmuisYaHmgZ7TOZQs7mV7u6vURGeDIsPfwHqW8LUp2WwOJ4DJY0UTtRAVJ3bOmIhRw3T3IBV3qOrk+4EaXCIPFjXhEryF9MPw0LApL7VwLgOxM006tzfTDv3eZDEgPd1FAJGYFA3U7gjCnDmvGsHgxVpTW7owcw4Laqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588128; c=relaxed/simple;
	bh=uw0HVyf3jX7kFfZ2aakVPCgH/SIuehr8fljh33Qsne0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=reFADbvOyxeAM67RuEXredBo2Qa7CiieEskH0OTlGYL86joDhuWhCb8FmU3mThxKBp3WW4+NBFS1TwniD8HJDlqeZkL04VpG1vlHzRaGTz+3QIcxmdArdlHAb8GfgYBgeLwvUSTYK03PwHLGBj4nVPXYwC2v9zrZfHGOaFEILbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2tN801A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2tN801A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059D3C433F1;
	Mon,  4 Mar 2024 21:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588128;
	bh=uw0HVyf3jX7kFfZ2aakVPCgH/SIuehr8fljh33Qsne0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2tN801Aw/uoEzpCRtZ+EF1N3Y/2BT02ApI+cZRl5PJv3gjo8+XXImufHoLWS7eoV
	 73R/edQwb9icVx8abFynwhFyeLO7Vo81YEW+jcWYfYbhYz0AJPrhrxB2mfQfKvWs3I
	 spu3+qzr6vIA8K8hbOkC1S15WWSKFkI66/h2sOds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Stephen Boyd <swboyd@chromium.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.10 32/42] pmdomain: qcom: rpmhpd: Fix enabled_corner aggregation
Date: Mon,  4 Mar 2024 21:23:59 +0000
Message-ID: <20240304211538.720993499@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211537.631764077@linuxfoundation.org>
References: <20240304211537.631764077@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <quic_bjorande@quicinc.com>

commit 2a93c6cbd5a703d44c414a3c3945a87ce11430ba upstream.

Commit 'e3e56c050ab6 ("soc: qcom: rpmhpd: Make power_on actually enable
the domain")' aimed to make sure that a power-domain that is being
enabled without any particular performance-state requested will at least
turn the rail on, to avoid filling DeviceTree with otherwise unnecessary
required-opps properties.

But in the event that aggregation happens on a disabled power-domain, with
an enabled peer without performance-state, both the local and peer
corner are 0. The peer's enabled_corner is not considered, with the
result that the underlying (shared) resource is disabled.

One case where this can be observed is when the display stack keeps mmcx
enabled (but without a particular performance-state vote) in order to
access registers and sync_state happens in the rpmhpd driver. As mmcx_ao
is flushed the state of the peer (mmcx) is not considered and mmcx_ao
ends up turning off "mmcx.lvl" underneath mmcx. This has been observed
several times, but has been painted over in DeviceTree by adding an
explicit vote for the lowest non-disabled performance-state.

Fixes: e3e56c050ab6 ("soc: qcom: rpmhpd: Make power_on actually enable the domain")
Reported-by: Johan Hovold <johan@kernel.org>
Closes: https://lore.kernel.org/linux-arm-msm/ZdMwZa98L23mu3u6@hovoldconsulting.com/
Cc:  <stable@vger.kernel.org>
Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Tested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240226-rpmhpd-enable-corner-fix-v1-1-68c004cec48c@quicinc.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/qcom/rpmhpd.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/soc/qcom/rpmhpd.c
+++ b/drivers/soc/qcom/rpmhpd.c
@@ -261,12 +261,15 @@ static int rpmhpd_aggregate_corner(struc
 	unsigned int active_corner, sleep_corner;
 	unsigned int this_active_corner = 0, this_sleep_corner = 0;
 	unsigned int peer_active_corner = 0, peer_sleep_corner = 0;
+	unsigned int peer_enabled_corner;
 
 	to_active_sleep(pd, corner, &this_active_corner, &this_sleep_corner);
 
-	if (peer && peer->enabled)
-		to_active_sleep(peer, peer->corner, &peer_active_corner,
+	if (peer && peer->enabled) {
+		peer_enabled_corner = max(peer->corner, peer->enable_corner);
+		to_active_sleep(peer, peer_enabled_corner, &peer_active_corner,
 				&peer_sleep_corner);
+	}
 
 	active_corner = max(this_active_corner, peer_active_corner);
 


