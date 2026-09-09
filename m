Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A93156E043;
	Wed,  9 Sep 2026 14:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963841; cv=none; b=edDgdc1KP4VccK8dT+PbvXIAn/TdHWqZYue6wNZvVYz4I0hjxnuanPOhjSwo/9AEgrrX0ZKXSigrxXbbSR9vM5qK2Rfqk9TdkMDFN21I64uF46/+P+zKZIzJHMVpkanMCAQAwrQuUvMMTUyaWZq+GSB+ijsKA+QjMoj87xM0r4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963841; c=relaxed/simple;
	bh=hn7VLkXuGRfJLQ3/u6C5E/kEbCR7sMVI8B1gr2LkrMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JjmhF4f0W0O8yladZqClq2U/ugwaSkAsT0qui4g1YurHIpbdIIuTcXhJNn0Q2oPjG6qalFJgJfjm5dWyoE+BlRM9A2zPTu4nTtfJDPugA+mMitUoP3g34Vtck2Moe4tp4+ARCmXFjSEB40d0n8ymFwowZ3XI6Ul4CFCvDtiEYOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VKkn+piu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VKkn+piu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952441F00A3A;
	Wed,  9 Sep 2026 14:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963840;
	bh=4EGx1Gk1ne7NxvoXhlYl/SYhsDuaI+TQUaPSMBEk0CA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VKkn+piuk54fIF1Us25OsAdCvFRcX9acwnrZGwNoCNeIfbx/i0zy+ZSiHQWNjkEEQ
	 dPMeSZ2t4G4es5JPYRemvfYnnN2iavx/1G6ackOVFm1r7K8NtfCk8CYJRnmMjQfHXH
	 8uPTnZsjaK4VcCLrn6Rp0JQDx8eyin5S1QgyEyj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giorgi Tchankvetadze <giorgi@tchankvetadze.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 215/583] iio: light: cm32181: return zero after writing calibscale
Date: Wed,  9 Sep 2026 15:38:20 +0200
Message-ID: <20260909134245.592413230@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>

commit 8756acd30919a3e9f547ea4a1d4b7f7895f4d340 upstream.

The write_raw callback is documented to return 0 on success or a
negative error code.  However, the IIO_CHAN_INFO_CALIBSCALE case
returns 'val' (the user-supplied value) instead of 0.

Fix it by returning 0 on success, matching the behavior of other
calibscale implementations in the subsystem.

Fixes: 971672c0b3cc ("iio: add Capella CM32181 ambient light sensor driver.")
Signed-off-by: Giorgi Tchankvetadze <giorgi@tchankvetadze.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/cm32181.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -369,7 +369,7 @@ static int cm32181_write_raw(struct iio_
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBSCALE:
 		cm32181->calibscale = val;
-		return val;
+		return 0;
 	case IIO_CHAN_INFO_INT_TIME:
 		ret = cm32181_write_als_it(cm32181, val2);
 		return ret;


