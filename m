Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058279;
	b=VCEr89xYt3cjmg4kP62ItFqMnWJv1dHeTpahLEgqm7tkk28tlb+qJ8ixS84qvNy+OQxp
	 fFg+wj8l1DY2xVWlYp+29mjVolFPUDG9YqtVgTSYESmfoRDHrpwwoW6k7ToDy7LGXZjiQ
	 a7/t3NvoJImIFUnPGykjwSQLZTB2YNOuMxGY+Ohyz27UFD/DLI6MlGlWM2cvqHlTPh2pd
	 75VyaxVPZEABFeZ7c+INlCHCuTzZUfDkqwIlCxgu1BZjjIl9+UnCI6OQPVB2TsygHPvNR
	 UtyGPYy7XsUQtk9G+FFG6EpUDKrRZg0aoDaR7Serx9cDsrgiKwc3tS8MAJgrGzzvsBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4ijSzKM50eoitaQaTOosd83PfV+BAbQfvksQkQ3+2HI=;
	b=ODN2cDo7U5lW/tmV62KEDNH3u92dYVqISYaA4OHxduJ06+hC3jZqARKs7IN+tKfyL2nu
	 Ts0ag3QFYOYEEgUENKJGZEOsLn/40aAT4f3QBSQIF/J/RTGEkziavbN4kGrJvFnEwzPmh
	 9+G106ePfGhoxNeI3l/SkUJHcjmy5DICwhRukwyF35UNH/JdcJOfKWYX7p+/BZy1vkWr5
	 3CWSj6DDUQ1rIghmHD3aNTa4XmKP8BNJQ/vvy8ksuu0ausO+UWoGQICHjtzaqH3uMfbPQ
	 rKiArgz+V5UFU/38bYuGvxvxuM1qNi1kxJZmcscqIompISuWKEDp+cw/b13WE9maOng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgZC+1Jp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35165606A31C;
	Thu, 19 Nov 2026 03:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tgZC+1Jp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83A151F000C4;
	Thu, 19 Nov 2026 03:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058279;
	bh=4ijSzKM50eoitaQaTOosd83PfV+BAbQfvksQkQ3+2HI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tgZC+1JpV/X7+meYKDIOb6Vlb5osdiX+Ad73mwSLdfJyaDm8bpexnAjhCA7/++MHa
	 Rw8ci5EV5KSlbuArxvjeb4tvLPHz367u1zXUBtdff4zCrzbsYY1d53+ZfYtIBCRzE/
	 3Cn2ZTJ7ZTWFR/yi6SGvq00V3Wbm2Sv++kKghT+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0428/1848] media: vpif_display: Fix i2c adapter reference leak in vpif_probe()
Date: Wed, 18 Nov 2026 15:41:06 +0100
Message-ID: <20261118145932.111852147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

[ Upstream commit f5863ea3f99265e5e297e3dcf0f47432fee2b8ac ]

vpif_probe() takes a reference to the i2c adapter with
i2c_get_adapter() and passes it to v4l2_i2c_new_subdev_board(),
which does not consume it, but the reference is never released, so
it is leaked both when the probe succeeds and when it fails after
the adapter has been acquired.

Release the reference with i2c_put_adapter() on the success path and
in the probe_subdev_out cleanup.

Fixes: e7332e3a552f ("V4L/DVB (12176): davinci/vpif_display: Add VPIF display driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/davinci/vpif_display.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/media/platform/davinci/vpif_display.c b/drivers/media/platform/davinci/vpif_display.c
index 46afc029138fc..988db0128f735 100644
--- a/drivers/media/platform/davinci/vpif_display.c
+++ b/drivers/media/platform/davinci/vpif_display.c
@@ -1336,11 +1336,14 @@ static __init int vpif_probe(struct platform_device *pdev)
 		}
 	}
 
+	i2c_put_adapter(i2c_adap);
+
 	return 0;
 
 probe_cleanup:
 	v4l2_async_notifier_cleanup(&vpif_obj.notifier);
 probe_subdev_out:
+	i2c_put_adapter(i2c_adap);
 	kfree(vpif_obj.sd);
 vpif_unregister:
 	v4l2_device_unregister(&vpif_obj.v4l2_dev);
-- 
2.53.0



