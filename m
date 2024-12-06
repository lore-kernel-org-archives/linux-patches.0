Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CC71149E0E;
	Fri,  6 Dec 2024 14:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496007; cv=none; b=DbfY2IJ57IXFIWvVni/QgEAJhv4qWQ5c8KKz5eiwhPu33NN6QegyB/016ecscJIhHA0WLvpq/8h6TNUIIKm7vPbUr1Cvya8eIbD7B9Kmh7k+pujOIMqHIBg+/Qlq28XheILASyyxjdKnsJb+Z5VY/h+yneZfZ/5ljZSwICPlTsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496007; c=relaxed/simple;
	bh=Wz0ydrHqn3O5LRHy7vAO9ZRKzrf5EajNtgxU5f5PoYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JVTzu7nplwf+WGwKT1RT6IpICY+M2fi7O5CvsxDMiU+DpnrNmDbffKHHISRNi/PHrfdc5XGjPZSXkOWglOXlejxlEhCvTDvgCBgZteObi5r4uRc16k3FDaMDXGtQc1vUgp3JhtAEowOqmGBGulgmBdEKo5wHmFmsUMSk4yor0ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2gBDUONA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2gBDUONA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00A9C4CEDC;
	Fri,  6 Dec 2024 14:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496007;
	bh=Wz0ydrHqn3O5LRHy7vAO9ZRKzrf5EajNtgxU5f5PoYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2gBDUONAsa1bopWUn+bt5/LW+A560T9ni2GJHSLQSXHJ8pG94P7G1CKTIZ7qvK9jv
	 3cIId4hf33BA1GY6c0GtkDUppCqu6aH7p5dK3nKhJRbGE4j7Zhf1grXoBMiNQhcycP
	 uwskwaIhXZojaFncAFVyHM/+H5BPQ47oLkXew4Is=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@nxp.com>,
	TaoJiang <tao.jiang_2@nxp.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.12 026/146] media: imx-jpeg: Ensure power suppliers be suspended before detach them
Date: Fri,  6 Dec 2024 15:35:57 +0100
Message-ID: <20241206143528.673846258@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Qian <ming.qian@nxp.com>

commit fd0af4cd35da0eb550ef682b71cda70a4e36f6b9 upstream.

The power suppliers are always requested to suspend asynchronously,
dev_pm_domain_detach() requires the caller to ensure proper
synchronization of this function with power management callbacks.
otherwise the detach may led to kernel panic, like below:

[ 1457.107934] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000040
[ 1457.116777] Mem abort info:
[ 1457.119589]   ESR = 0x0000000096000004
[ 1457.123358]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 1457.128692]   SET = 0, FnV = 0
[ 1457.131764]   EA = 0, S1PTW = 0
[ 1457.134920]   FSC = 0x04: level 0 translation fault
[ 1457.139812] Data abort info:
[ 1457.142707]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[ 1457.148196]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[ 1457.153256]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[ 1457.158563] user pgtable: 4k pages, 48-bit VAs, pgdp=00000001138b6000
[ 1457.165000] [0000000000000040] pgd=0000000000000000, p4d=0000000000000000
[ 1457.171792] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[ 1457.178045] Modules linked in: v4l2_jpeg wave6_vpu_ctrl(-) [last unloaded: mxc_jpeg_encdec]
[ 1457.186383] CPU: 0 PID: 51938 Comm: kworker/0:3 Not tainted 6.6.36-gd23d64eea511 #66
[ 1457.194112] Hardware name: NXP i.MX95 19X19 board (DT)
[ 1457.199236] Workqueue: pm pm_runtime_work
[ 1457.203247] pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 1457.210188] pc : genpd_runtime_suspend+0x20/0x290
[ 1457.214886] lr : __rpm_callback+0x48/0x1d8
[ 1457.218968] sp : ffff80008250bc50
[ 1457.222270] x29: ffff80008250bc50 x28: 0000000000000000 x27: 0000000000000000
[ 1457.229394] x26: 0000000000000000 x25: 0000000000000008 x24: 00000000000f4240
[ 1457.236518] x23: 0000000000000000 x22: ffff00008590f0e4 x21: 0000000000000008
[ 1457.243642] x20: ffff80008099c434 x19: ffff00008590f000 x18: ffffffffffffffff
[ 1457.250766] x17: 5300326563697665 x16: 645f676e696c6f6f x15: 63343a6d726f6674
[ 1457.257890] x14: 0000000000000004 x13: 00000000000003a4 x12: 0000000000000002
[ 1457.265014] x11: 0000000000000000 x10: 0000000000000a60 x9 : ffff80008250bbb0
[ 1457.272138] x8 : ffff000092937200 x7 : ffff0003fdf6af80 x6 : 0000000000000000
[ 1457.279262] x5 : 00000000410fd050 x4 : 0000000000200000 x3 : 0000000000000000
[ 1457.286386] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff00008590f000
[ 1457.293510] Call trace:
[ 1457.295946]  genpd_runtime_suspend+0x20/0x290
[ 1457.300296]  __rpm_callback+0x48/0x1d8
[ 1457.304038]  rpm_callback+0x6c/0x78
[ 1457.307515]  rpm_suspend+0x10c/0x570
[ 1457.311077]  pm_runtime_work+0xc4/0xc8
[ 1457.314813]  process_one_work+0x138/0x248
[ 1457.318816]  worker_thread+0x320/0x438
[ 1457.322552]  kthread+0x110/0x114
[ 1457.325767]  ret_from_fork+0x10/0x20

Fixes: 2db16c6ed72c ("media: imx-jpeg: Add V4L2 driver for i.MX8 JPEG Encoder/Decoder")
Cc: <stable@vger.kernel.org>
Signed-off-by: Ming Qian <ming.qian@nxp.com>
Reviewed-by: TaoJiang <tao.jiang_2@nxp.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/nxp/imx-jpeg/mxc-jpeg.c
@@ -2679,6 +2679,8 @@ static void mxc_jpeg_detach_pm_domains(s
 	int i;
 
 	for (i = 0; i < jpeg->num_domains; i++) {
+		if (jpeg->pd_dev[i] && !pm_runtime_suspended(jpeg->pd_dev[i]))
+			pm_runtime_force_suspend(jpeg->pd_dev[i]);
 		if (jpeg->pd_link[i] && !IS_ERR(jpeg->pd_link[i]))
 			device_link_del(jpeg->pd_link[i]);
 		if (jpeg->pd_dev[i] && !IS_ERR(jpeg->pd_dev[i]))


