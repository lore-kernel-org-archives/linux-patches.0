Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E9511C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95DBFC433C7;
	Mon, 28 Aug 2023 10:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218405;
	bh=UzWPPFglri7Fszo/1RAkwjU7ydSsf18YWwVP9VZL4Lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCYtpL6hluxQYZ7VTd2B15dFgU8KF2aSIAPHomajXc/34S1u7JeqN3crhb3Y1n9qk
	 1TVKgqt51SH+1gohiPaTMn70OUCXivpu/XIuUnouxgx+FzGF4qQnsxSaH9ccU+3ZZx
	 9T7vsk0YDVE1Ek6axG/VcIvwDkQYefcoFtuRpoHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	Tony Lindgren <tony@atomide.com>
Subject: [PATCH 4.19 075/129] bus: ti-sysc: Flush posted write on enable before reset
Date: Mon, 28 Aug 2023 12:12:49 +0200
Message-ID: <20230828101156.100043904@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

commit 34539b442b3bc7d5bf10164750302b60b91f18a7 upstream.

The am335x devices started producing boot errors for resetting musb module
in because of subtle timing changes:

Unhandled fault: external abort on non-linefetch (0x1008)
...
sysc_poll_reset_sysconfig from sysc_reset+0x109/0x12
sysc_reset from sysc_probe+0xa99/0xeb0
...

The fix is to flush posted write after enable before reset during
probe. Note that some devices also need to specify the delay after enable
with ti,sysc-delay-us, but this is not needed for musb on am335x based on
my tests.

Reported-by: kernelci.org bot <bot@kernelci.org>
Closes: https://storage.kernelci.org/next/master/next-20230614/arm/multi_v7_defconfig+CONFIG_THUMB2_KERNEL=y/gcc-10/lab-cip/baseline-beaglebone-black.html
Fixes: 596e7955692b ("bus: ti-sysc: Add support for software reset")
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/ti-sysc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -978,6 +978,8 @@ static int sysc_reset(struct sysc *ddata
 	val = sysc_read(ddata, offset);
 	val |= (0x1 << ddata->cap->regbits->srst_shift);
 	sysc_write(ddata, offset, val);
+	/* Flush posted write */
+	val = sysc_read_sysconfig(ddata);
 
 	/* Poll on reset status */
 	offset = ddata->offsets[SYSC_SYSSTATUS];


