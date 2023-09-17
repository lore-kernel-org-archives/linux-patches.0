Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527276FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B73B6C433C7;
	Sun, 17 Sep 2023 20:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694982711;
	bh=Fq3a+5sQn52F4LmjPKYOGzv2i6scZQ47jVaVWl3y9ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pq9qzgaaNnz9RDkwF+m9oezaveXeSYILsVBhDfW18Rtikz995uf371wtOIueFpba6
	 9x2gbGPhONJb0cShaOGVm2hJQ3nIvD/30A23et/SZ9iQdnzuE0YMwNIcPJOCuZbhn1
	 38lYE3d04Yo2DYaduWh1WjGZQGyiDAuP6W2Ng6e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	"GONG, Ruiqi" <gongruiqi@huaweicloud.com>,
	Corey Minyard <minyard@acm.org>,
	GONG
Subject: [PATCH 5.15 330/511] ipmi_si: fix a memleak in try_smi_init()
Date: Sun, 17 Sep 2023 21:12:37 +0200
Message-ID: <20230917191121.784589314@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

commit 6cf1a126de2992b4efe1c3c4d398f8de4aed6e3f upstream.

Kmemleak reported the following leak info in try_smi_init():

unreferenced object 0xffff00018ecf9400 (size 1024):
  comm "modprobe", pid 2707763, jiffies 4300851415 (age 773.308s)
  backtrace:
    [<000000004ca5b312>] __kmalloc+0x4b8/0x7b0
    [<00000000953b1072>] try_smi_init+0x148/0x5dc [ipmi_si]
    [<000000006460d325>] 0xffff800081b10148
    [<0000000039206ea5>] do_one_initcall+0x64/0x2a4
    [<00000000601399ce>] do_init_module+0x50/0x300
    [<000000003c12ba3c>] load_module+0x7a8/0x9e0
    [<00000000c246fffe>] __se_sys_init_module+0x104/0x180
    [<00000000eea99093>] __arm64_sys_init_module+0x24/0x30
    [<0000000021b1ef87>] el0_svc_common.constprop.0+0x94/0x250
    [<0000000070f4f8b7>] do_el0_svc+0x48/0xe0
    [<000000005a05337f>] el0_svc+0x24/0x3c
    [<000000005eb248d6>] el0_sync_handler+0x160/0x164
    [<0000000030a59039>] el0_sync+0x160/0x180

The problem was that when an error occurred before handlers registration
and after allocating `new_smi->si_sm`, the variable wouldn't be freed in
the error handling afterwards since `shutdown_smi()` hadn't been
registered yet. Fix it by adding a `kfree()` in the error handling path
in `try_smi_init()`.

Cc: stable@vger.kernel.org # 4.19+
Fixes: 7960f18a5647 ("ipmi_si: Convert over to a shutdown handler")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Co-developed-by: GONG, Ruiqi <gongruiqi@huaweicloud.com>
Signed-off-by: GONG, Ruiqi <gongruiqi@huaweicloud.com>
Message-Id: <20230629123328.2402075-1-gongruiqi@huaweicloud.com>
Signed-off-by: Corey Minyard <minyard@acm.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmi_si_intf.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2081,6 +2081,11 @@ static int try_smi_init(struct smi_info
 		new_smi->io.io_cleanup = NULL;
 	}
 
+	if (rv && new_smi->si_sm) {
+		kfree(new_smi->si_sm);
+		new_smi->si_sm = NULL;
+	}
+
 	return rv;
 }
 


