Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4918417BF8;
	Fri,  4 Sep 2026 06:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501807; cv=none; b=SMnIiYNy4SDAX+fmbjS1LaM9mr51WB3OzgOO8Ci+IpqDqYSTSrPTzAq+WLFCf6ihX9FSDlzWhQW/llr8kgFPRkPOPKVe6mEVcbk7goHHenmb6f3muhLZBvi0E9mx18aR43ywSApwVJUyemhs0q1z1PDl3n3ZxgYKffJaHtZ7m48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501807; c=relaxed/simple;
	bh=jBXtXwC9B8b90YLWeEet812grWKHpW7SQuyCv7HC4js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLzlAVP9/xdeBLMT+y7DCstYtsJEI+ZR5u2JoeNkWS+IzBv1rfTk7Z7mWDJGHvr/aeL+whOOgaNqr0HN8oGLAa6ukWrTyPpywm6Z0ssxyiv8MFmx3Rizr9cyMlY8Qjqrg42B1+Hxc3LuZyra+g3UUhWw36vQFItgwJP74ahocxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsefnuOz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsefnuOz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4D351F00A3D;
	Fri,  4 Sep 2026 06:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501806;
	bh=Cn2lbQcZXeaGNtCkOzPExulDSqxeRSnoZAT2nGZKVwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HsefnuOzwZb/hHQ3ZknonK5shYGKeEUnda8+y3A/gqwqk/PhJaa0x1+OC8e1oX340
	 2OxcXJZdFSgPyQgNmkncyiaNNJdVtwBSY/edlbTV1uFqc4FjBG/TRW2ocFftdUpFYL
	 v3Lg86YvToIS/txCZIPjXjtpb1NtNAdYcEXo4Npg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawei Feng <dawei.feng@seu.edu.cn>,
	Ping-Ke Shih <pkshih@realtek.com>
Subject: [PATCH 6.18 532/552] wifi: rtw88: pci: fix resource leak on failed NAPI setup
Date: Fri,  4 Sep 2026 07:01:29 +0200
Message-ID: <20260904045802.678653462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Dawei Feng <dawei.feng@seu.edu.cn>

commit e779df4806cd29cbcca5c9dc0a1073662c76b889 upstream.

rtw_pci_probe() allocates PCI resources through
rtw_pci_setup_resource() before it sets up NAPI. If
rtw_pci_napi_init() fails, the error path jumps straight to
err_pci_declaim and skips rtw_pci_destroy(), leaving the PCI
resources allocated by rtw_pci_setup_resource() behind.

Add a dedicated cleanup label for the NAPI setup failure path so probe
destroys the PCI resources.

The bug was first flagged by an experimental analysis tool we are
developing for kernel memory-management bugs while analyzing current
mainline kernels. The tool is still under development and is not yet
publicly available. Manual inspection confirms that the bug is still
present in v7.1-rc7.

An x86_64 allyesconfig build showed no new warnings. As we do not have a
suitable rtw88 PCI board to test with, no runtime testing was able to be
performed.

Fixes: d0bcb10e7b94 ("wifi: rtw88: Un-embed dummy device")
Cc: stable@vger.kernel.org
Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260617013502.114057-1-dawei.feng@seu.edu.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1799,7 +1799,7 @@ int rtw_pci_probe(struct pci_dev *pdev,
 	ret = rtw_pci_napi_init(rtwdev);
 	if (ret) {
 		rtw_err(rtwdev, "failed to setup NAPI\n");
-		goto err_pci_declaim;
+		goto err_destroy_rsrc;
 	}
 
 	ret = rtw_chip_info_setup(rtwdev);
@@ -1831,6 +1831,8 @@ int rtw_pci_probe(struct pci_dev *pdev,
 
 err_destroy_pci:
 	rtw_pci_napi_deinit(rtwdev);
+
+err_destroy_rsrc:
 	rtw_pci_destroy(rtwdev, pdev);
 
 err_pci_declaim:


