Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729371C5783;
	Tue, 27 Aug 2024 14:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770369; cv=none; b=obhJlUgE772Des8WCN+gMk42bJJw1CGlO1lfx8hkHUp97+HZCf4dSQ+Gl/+0pyKXCWii40Pt0Bn+jkqLisBIOGxlxXRLdnNk3asgjuQ4qnee4mBX5xPJiv+i7sw7YfeOQTWptD8lmMeB2Rz/Nm6x0H1yiVQtsW04OE5bbv4y0XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770369; c=relaxed/simple;
	bh=sPtiFiufQTjkL0Bz9u+ZGf5GpbNVXWX1N1fbtYGFJjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVjQMiSLih++URLitaru8xVmxCngjb2U0ljF7w6UghWnYNJ6mZn0SsyWx0iKYecyz0+74ucdPqHFPn8QyGq0HLENvKnjRvGCo6dn+9WRBkWrU7JNZz5ObewKS9yJ+xfrOdNEolCbUV6Z4OxzDAjP9FMJm5DWGPT2Ijijkw9YJP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B5COx5Rx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B5COx5Rx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D457C6104A;
	Tue, 27 Aug 2024 14:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770369;
	bh=sPtiFiufQTjkL0Bz9u+ZGf5GpbNVXWX1N1fbtYGFJjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B5COx5RxIhDAvnOAh2ExrZr+iBlO5U9XdgSGenj3ESioE4cCDAx4TrTMVmfUminf0
	 7WHc1dfCDUZS4whfVnnNB5/xcT8Ocf6nnsUTWzUR02T8ZIHBZHVUuaY5S0R92wt5Nh
	 +YraUhDItMufj1jiv1+afudouZG0BQ6kEwxqckMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Krishna Kurapati <quic_kriskura@quicinc.com>,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 208/341] usb: dwc3: core: Skip setting event buffers for host only controllers
Date: Tue, 27 Aug 2024 16:37:19 +0200
Message-ID: <20240827143851.327898623@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Krishna Kurapati <quic_kriskura@quicinc.com>

[ Upstream commit 89d7f962994604a3e3d480832788d06179abefc5 ]

On some SoC's like SA8295P where the tertiary controller is host-only
capable, GEVTADDRHI/LO, GEVTSIZ, GEVTCOUNT registers are not accessible.
Trying to access them leads to a crash.

For DRD/Peripheral supported controllers, event buffer setup is done
again in gadget_pullup. Skip setup or cleanup of event buffers if
controller is host-only capable.

Suggested-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Krishna Kurapati <quic_kriskura@quicinc.com>
Acked-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Reviewed-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Tested-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20240420044901.884098-4-quic_kriskura@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc3/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
index 674467b7638ea..5ce276cb39d0d 100644
--- a/drivers/usb/dwc3/core.c
+++ b/drivers/usb/dwc3/core.c
@@ -506,6 +506,13 @@ static void dwc3_free_event_buffers(struct dwc3 *dwc)
 static int dwc3_alloc_event_buffers(struct dwc3 *dwc, unsigned int length)
 {
 	struct dwc3_event_buffer *evt;
+	unsigned int hw_mode;
+
+	hw_mode = DWC3_GHWPARAMS0_MODE(dwc->hwparams.hwparams0);
+	if (hw_mode == DWC3_GHWPARAMS0_MODE_HOST) {
+		dwc->ev_buf = NULL;
+		return 0;
+	}
 
 	evt = dwc3_alloc_one_event_buffer(dwc, length);
 	if (IS_ERR(evt)) {
@@ -527,6 +534,9 @@ int dwc3_event_buffers_setup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
 
+	if (!dwc->ev_buf)
+		return 0;
+
 	evt = dwc->ev_buf;
 	evt->lpos = 0;
 	dwc3_writel(dwc->regs, DWC3_GEVNTADRLO(0),
@@ -544,6 +554,9 @@ void dwc3_event_buffers_cleanup(struct dwc3 *dwc)
 {
 	struct dwc3_event_buffer	*evt;
 
+	if (!dwc->ev_buf)
+		return;
+
 	evt = dwc->ev_buf;
 
 	evt->lpos = 0;
-- 
2.43.0



