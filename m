Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208688;
	b=zAVzh+mM9T0CxKULsl5emOkhwyiqpjByR6cjNr8AJD7JG0Ks0A2i79nbOyAjvMJsXzXr
	 0YEqTrbBg/UNgfWAwyi/o3g6mH63JRUpc2VnT2hsGdrpYOi04jHNXQl3bHDpz21MkQP8R
	 Mvbhdr5rYtRj53epA134qM9mpL7HPynGzyN7NYSAED03eD7r1PlO6pN8zgbyryimR2rI0
	 YSkSg/xeJxIRNvGCe2rLorxmQjHRqwrupRcZCuM+RIGKy4+jBTp/TTIQbqpM+M9qIxs57
	 t2y2LB96PctcAcjd5UGKMFP1W4zLu4uFAycYErUUWchsoHJyouwjQDMs/Dz8y0atkVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kN/eB6TxZjQCfaAih8DGErWAWysWjLqcymFlzcuzssQ=;
	b=bCPwNgwu1VI25CJGFKj96fCfb0TjejBUMaPfDJcL+Ba51JiJuRRxpFeIJ23dHe99ULrx
	 5u+GjYC1X0LDxa6yo9qx40sgupoRJ+eybVu57F091uJXvHli6TjVgr7qzH7PyEsvG/ve6
	 zvqjwHSODNf3DljtWb6TXyzVpqu86DdrFOnYo2C9U7P/cBEFk8yWgN/AjiUMAw3UzwYCL
	 +ntBAEVMoXazDKmYB5d1eJfgPx+20bkg9QvB9pgPDxAEWKgOsF4thXvEfe7NIr+PJhRWX
	 PlKq8CxvVkbyGT8xK1taly0CO9f7ZMV+aUYS3dHl7lGGWy7LDIB6uSxa08mZzVFwmsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdvxpThf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11B7606A31C;
	Wed, 28 Oct 2026 17:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OdvxpThf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B411F01828;
	Wed, 28 Oct 2026 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208687;
	bh=kN/eB6TxZjQCfaAih8DGErWAWysWjLqcymFlzcuzssQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OdvxpThfUyMutwvfNiJ5ca1Ge5dwZUQc8qIC6Ao2r4CwB5lXGZl3u53Jl1Ff5VGyf
	 +UW4AqjHdJayRfkaaHKGyogxVyaruZ0UI8wVeUYaLtafkVJL/ahZceLbTi5n0y3S28
	 WwoQx+rDs+OGUK6vXDeq/khn3K7NTs3tFcObw2MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 5.10 207/516] serial: vt8500: Fix clock reference leak in vt8500_serial_probe()
Date: Wed, 28 Oct 2026 17:55:59 +0100
Message-ID: <20261028170008.405224703@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 9d8955281d9229a899e2041659a59b389027b711 upstream.

of_clk_get() returns a clock with a reference that has to be released
with clk_put(). If clk_prepare_enable() fails the function returns
without doing so, leaking the reference.

Add the missing clk_put() on that error path.

Fixes: 12faa35ae5cb ("serial: vt8500: UART uses gated clock rather than 24Mhz reference")
Cc: stable@kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917155834.2161361-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/vt8500_serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -682,6 +682,7 @@ static int vt8500_serial_probe(struct pl
 	ret = clk_prepare_enable(vt8500_port->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
+		clk_put(vt8500_port->clk);
 		return ret;
 	}
 


