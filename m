Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F77D1A76A9;
	Tue, 30 Jul 2024 17:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360122; cv=none; b=NpQMpK8f1aDzDBDRhn7u1XQXSsG2+Psv1Yjg1vT4H+Uw9jGyljFVgcYtqqx12kUvEpYXl3RFTnMmC/a90uN9ktQci03lKphbNnLEobIrrAZEMP3esLN81mvKtY9yaHNd5/BqpYp5VmLlEa3IRZg8kdW3PN7wKuVnPacePMsmlUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360122; c=relaxed/simple;
	bh=0HiTSvT1hwY+Cwq0cfIj3qXIQzq8+V3iyKyRCiVTZvI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qUSnoyaQN+dfkmi0Z6hbCrue3Tzl4gzMvvXV0KOz1SqLzuzhys9Kc/1HWfDoqXqyRXlVCbxBaCi+Z7BtDzxQQxGH9lVM8hJR3xznmMivLm0IOqquimu8jY796rJzGANEsvlc876+VYdrvtKxirO7TGX+mF/zgM+dbMKpAq68yWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wdCzWl2I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wdCzWl2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA4FC32782;
	Tue, 30 Jul 2024 17:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360121;
	bh=0HiTSvT1hwY+Cwq0cfIj3qXIQzq8+V3iyKyRCiVTZvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdCzWl2IwX5y3piwTPFxyCx6vmh/o7HLYAEYM7hFXlSXYxuw0VLhLVmnM1FMGE4pz
	 994s0Heok/Ejti93b6BKWmZqxJjjRHUbYvIZpGJYv/ZR5wMR/Qk9wb9VXqACndrkyB
	 suNYlPfWmuRHBt0a6p+IPxKW3IE+2AXp79taPnO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Michal Simek <michal.simek@amd.com>
Subject: [PATCH 6.10 604/809] drivers: soc: xilinx: check return status of get_api_version()
Date: Tue, 30 Jul 2024 17:48:00 +0200
Message-ID: <20240730151748.690527121@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Buddhabhatti <jay.buddhabhatti@amd.com>

commit 9b003e14801cf85a8cebeddc87bc9fc77100fdce upstream.

Currently return status is not getting checked for get_api_version
and because of that for x86 arch we are getting below smatch error.

    CC      drivers/soc/xilinx/zynqmp_power.o
drivers/soc/xilinx/zynqmp_power.c: In function 'zynqmp_pm_probe':
drivers/soc/xilinx/zynqmp_power.c:295:12: warning: 'pm_api_version' is
used uninitialized [-Wuninitialized]
    295 |         if (pm_api_version < ZYNQMP_PM_VERSION)
        |            ^
    CHECK   drivers/soc/xilinx/zynqmp_power.c
drivers/soc/xilinx/zynqmp_power.c:295 zynqmp_pm_probe() error:
uninitialized symbol 'pm_api_version'.

So, check return status of pm_get_api_version and return error in case
of failure to avoid checking uninitialized pm_api_version variable.

Fixes: b9b3a8be28b3 ("firmware: xilinx: Remove eemi ops for get_api_version")
Signed-off-by: Jay Buddhabhatti <jay.buddhabhatti@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240515112345.24673-1-jay.buddhabhatti@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/soc/xilinx/zynqmp_power.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -190,7 +190,9 @@ static int zynqmp_pm_probe(struct platfo
 	u32 pm_api_version;
 	struct mbox_client *client;
 
-	zynqmp_pm_get_api_version(&pm_api_version);
+	ret = zynqmp_pm_get_api_version(&pm_api_version);
+	if (ret)
+		return ret;
 
 	/* Check PM API version number */
 	if (pm_api_version < ZYNQMP_PM_VERSION)


