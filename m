Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6FDED531;
	Tue, 14 May 2024 10:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684176; cv=none; b=KMrRRXznzri/VnBcelf4ol6J5TexrsKZuxhlBWLDFK1JpqqynVSKM+KOyFh8+TTLG2Ay3y2DWMojeIYSrfnErdD/2m2lWK3hZbHq12lGtrvTUK5RHUOAmThV8eaoDW6PVPznlN6c/zpiya1jCGcl4SV3OnMVs1mvNXwCJzQKXIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684176; c=relaxed/simple;
	bh=rZmm9UkglMHxq1fu1Y86rpaMyI6NOfF8bsbSYsNudg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWel/ENGPUid90jjJuxjG10jKeFsPrDwdl6ROSir8wnF7KzIvs7iU1xtMLq57At5soPoNHsS/A3Zow8v+B7U9WVgK5nC64dWNgS4MElpvMrTHzcTwxrZAqTzpl6hVNMVMjYAldotcEobLj9JbGNHTKTsaR32wv98c9yaXFDL06o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrQZX+nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrQZX+nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B22CC2BD10;
	Tue, 14 May 2024 10:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684176;
	bh=rZmm9UkglMHxq1fu1Y86rpaMyI6NOfF8bsbSYsNudg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hrQZX+nZz+86T1YO2NM0hAdw50SftG83XVjQKBpKdvkjQMzAAb4R7wQVtiyac/wSd
	 D2bXf+cXGZPUMdynOzwxZVMzhH5c1WVpRNwfEKvMicGwgftMT/2TdCg9u+HWGAD2YE
	 P/LN92WtJBiXVVnKp3ycCsU1psjXxXKIWhYNa8iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Subject: [PATCH 6.8 336/336] Bluetooth: qca: fix firmware check error path
Date: Tue, 14 May 2024 12:19:00 +0200
Message-ID: <20240514101051.314434161@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit 40d442f969fb1e871da6fca73d3f8aef1f888558 upstream.

A recent commit fixed the code that parses the firmware files before
downloading them to the controller but introduced a memory leak in case
the sanity checks ever fail.

Make sure to free the firmware buffer before returning on errors.

Fixes: f905ae0be4b7 ("Bluetooth: qca: add missing firmware sanity checks")
Cc: stable@vger.kernel.org      # 4.19
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btqca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btqca.c
+++ b/drivers/bluetooth/btqca.c
@@ -605,7 +605,7 @@ static int qca_download_firmware(struct
 
 	ret = qca_tlv_check_data(hdev, config, data, size, soc_type);
 	if (ret)
-		return ret;
+		goto out;
 
 	segment = data;
 	remain = size;


