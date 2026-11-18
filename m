Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048277;
	b=gwtNVnFLU5kjHFYMsnOkss4bvtL7nLMM7SpspBx+gixa16L9tCXZuk6x3YiN1ZEsavnh
	 qnOB7i4hqfTp9n4Haa76q+Gfn7RXOMtdQvV4ZTUUaOXb4Myvgh4xbD8x4BWFQS671IlCx
	 e+VUS17aDWF0Hu6YUSZjlZd6A6lOwYcAhqrw1o+RpY6qLLicSCoMjUK7+MPVrYprQsjtW
	 yOB9tb6kWVP0jmWpP58LADFY8a/Wr96zFIv1qLS03ybM9furVVvScNzWCXT8x+V1q0TYj
	 V0DvZD+00AowJOx4bbTQeTSOFpz9YAq5w4QGm2U+d++R2GWozhywhFa66BnfMFPkDHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s52tUGmiVkvbOTBZb4cNWix73UHDG6JgMM++Aud5Ork=;
	b=WeG1W9WwDqsuk9z/cgp0NV40WNrlR7HE95lspaP7pwkfFgP8n7zKzWVaGA82D9Mjh4I9
	 kZNs4pBoZ+v4k9nyDO8ze+n0JVvbKoPwV+gW8y0vclKUEtk3L9Ss2xcA2x7+xYNOhXXn/
	 cE3LeL6ZdByvO+MShoNHUk/xcM8dEfoBt4auKDQgdwNX/TwQcK8lrt4OyKDo6FygXy3Mq
	 NbrusfLpW/RpVpCd/0VM8O/1msfnXfOzXnWu+ttRcVfhr5QMTC8ytLny5QRWo2coTPuBl
	 +x8vsnO63GMwKdaFX8CcZa/Q4P1JoUhDIHMt5sLPgVWpRsQfKs4MDtXg2N4LBQS09RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bpgFBapQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 374B0606A325;
	Thu, 19 Nov 2026 00:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bpgFBapQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D30E1F000C4;
	Thu, 19 Nov 2026 00:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048277;
	bh=s52tUGmiVkvbOTBZb4cNWix73UHDG6JgMM++Aud5Ork=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bpgFBapQYK5rdm0AK4ngYNOPmk4K6hProFUw+0y5NJkoFWDYwpCYhvHaQIiECZcu+
	 A6MdlMlhaItHpWPAAQ0ns8jg0ikPSeFpksetrK7uU9I9nbbsyqOS+lShXpXTgWLe8T
	 hrFW7hZLyyyr22117qjdGAvPQXMrJBsNa+QAsQSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linkai Gong <gonglinkai@kylinos.cn>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1936/2857] firmware: imx: dsp: fix mailbox channel leak on kasprintf failure
Date: Wed, 18 Nov 2026 15:49:30 +0100
Message-ID: <20261118150310.920338967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linkai Gong <gonglinkai@kylinos.cn>

[ Upstream commit e3631d0242842940f9e902afaea98202e56277e8 ]

If kasprintf() fails while setting up mailbox channels, already
requested channels from earlier iterations were never freed. Route
the failure through the existing cleanup path.

Fixes: ffbf23d50353 ("firmware: imx: Add DSP IPC protocol interface")
Signed-off-by: Linkai Gong <gonglinkai@kylinos.cn>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/imx/imx-dsp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/imx/imx-dsp.c b/drivers/firmware/imx/imx-dsp.c
index 0f656e4191d5c..e0419f908f6bd 100644
--- a/drivers/firmware/imx/imx-dsp.c
+++ b/drivers/firmware/imx/imx-dsp.c
@@ -100,8 +100,10 @@ static int imx_dsp_setup_channels(struct imx_dsp_ipc *dsp_ipc)
 		else
 			chan_name = kasprintf(GFP_KERNEL, "rxdb%d", i - 2);
 
-		if (!chan_name)
-			return -ENOMEM;
+		if (!chan_name) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
 		dsp_chan = &dsp_ipc->chans[i];
 		dsp_chan->name = chan_name;
-- 
2.53.0



