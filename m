Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 721E426B0BC;
	Thu, 13 Feb 2025 14:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458173; cv=none; b=tefqCUWdTEh7zs8CRDxwTXw1oTjIOzdvwWtLBCW8doyIHnNtyGgQ4N75ov9PDnldRJgCw+NZlwXjGJaOB5rvkJdhZtQn/gJlD+rIuet2k58HSqdoSz+JMwZhGWo5H3CLseJx5uFlRUPu2Xh4zb7cETIkCp2VM0yYN0YHlJ3aNfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458173; c=relaxed/simple;
	bh=uvSUdEixzj/WgaQrw9ECsVhd0POQIP9wsxGET9NQX+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y+1XSNmkgn5PaIMHyV41N5VEdxYtS1uSHwpMKPS1DYh/EclQcXJvS47gM46Bpqp5XhMgp/ZVOuHF3uYtAnlxV5Urx4MjeEAcAgWbk/rQLH9C/CHdeNgubSxsZ1scWWcprcA8moeOhBNnnhk6iuAE1vbDTN6y1VGMFsJX/18Nhts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CaJdv3DT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CaJdv3DT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1FC5C4CED1;
	Thu, 13 Feb 2025 14:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458173;
	bh=uvSUdEixzj/WgaQrw9ECsVhd0POQIP9wsxGET9NQX+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaJdv3DT/lvaBZyXbZ7+QXHkxrb7hX30I6awTnC+TLCrLl877loe2ElyOQLUwAH++
	 DA3msQc1axeJkT/ix8vC9LhnALUtiuuv1GrFhy9lCgTihJDuEiHT/+1X20JUB8WAyr
	 bd0KhmnqIgUSgiIcnxMJY6B2pkVyhp7dml64QsSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.12 323/422] media: nuvoton: Fix an error check in npcm_video_ece_init()
Date: Thu, 13 Feb 2025 15:27:52 +0100
Message-ID: <20250213142449.016128180@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

commit c4b7779abc6633677e6edb79e2809f4f61fde157 upstream.

When function of_find_device_by_node() fails, it returns NULL instead of
an error code. So the corresponding error check logic should be modified
to check whether the return value is NULL and set the error code to be
returned as -ENODEV.

Fixes: 46c15a4ff1f4 ("media: nuvoton: Add driver for NPCM video capture and encoding engine")
Cc: stable@vger.kernel.org
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20241015014053.669-1-thunder.leizhen@huawei.com
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nuvoton/npcm-video.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/platform/nuvoton/npcm-video.c
+++ b/drivers/media/platform/nuvoton/npcm-video.c
@@ -1667,9 +1667,9 @@ static int npcm_video_ece_init(struct np
 		dev_info(dev, "Support HEXTILE pixel format\n");
 
 		ece_pdev = of_find_device_by_node(ece_node);
-		if (IS_ERR(ece_pdev)) {
+		if (!ece_pdev) {
 			dev_err(dev, "Failed to find ECE device\n");
-			return PTR_ERR(ece_pdev);
+			return -ENODEV;
 		}
 		of_node_put(ece_node);
 


