Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3A833A033;
	Wed, 20 May 2026 17:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297353; cv=none; b=OKVIoexR5N2sdnSrBONYWU1u6ESf+uzFECB0cxjUawuOZg7SZ9zjDI3JnYzaboDMCphzHx7+A636m5i9/Yv5mMAr6wqUFrYjzX51rO0hwKj/tNYWMo9T7wJV0ocWB8RoyLhsBfMfS1ln5Iv6yXvxAwDRzTsCAZLJLIVxEBb0EOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297353; c=relaxed/simple;
	bh=CBasPb+7QbyPJLrzFAYOccCIUtjxR83ljQZPGOF3/vk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IIEsfT1OyjS0SkSNAMDCcImCleLEgf1qEVyNyTAlmcOk/s4LXvMJrpeA8USZWQnhYU4G1qpVxDCDpYHf+RdqFQem0MWfX/q+RRobwA6wug/+jG25nSvIym+nGxC4bpOwWBCEKYiCDXtIdqt12eABXsUBi5LL3T8Nmtj55qimXc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0dsOHuou; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0dsOHuou"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1C01F000E9;
	Wed, 20 May 2026 17:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297351;
	bh=ae5nYhguWVFVQr5CwXcc4nJfFR9ndmTSLcD24LiuQvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0dsOHuouZRmQP38tTp/1jw8ImTlLDe1CpdUWXcS+U1GTEi+fs3NE1JA8kfI4KGuS0
	 713pOJypFOEChIu2ifTx+WPtmVvciVARw2B8lexu/zndwv9WWDskzdnnRr+8LrrQdf
	 vjaDkC3aGx6pXwZhDlqoeigmBfPiooz3jGheO4TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Subject: [PATCH 7.0 1134/1146] drm/gma500/oaktrail_hdmi: fix i2c adapter leak on setup
Date: Wed, 20 May 2026 18:23:04 +0200
Message-ID: <20260520162213.916004198@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 950953f774b3f69da6f413e045ef075e1f3da2df upstream.

Make sure to drop the reference taken to the I2C adapter (and its
module) when setting up HDMI to allow the adapter to be deregistered.

Fixes: 1b082ccf5901 ("gma500: Add Oaktrail support")
Cc: stable@vger.kernel.org	# 3.3
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Link: https://patch.msgid.link/20260508144446.59722-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/gma500/oaktrail_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/gma500/oaktrail_hdmi.c
+++ b/drivers/gpu/drm/gma500/oaktrail_hdmi.c
@@ -580,6 +580,7 @@ static int oaktrail_hdmi_get_modes(struc
 	} else {
 		edid = (struct edid *)raw_edid;
 		/* FIXME ? edid = drm_get_edid(connector, i2c_adap); */
+		i2c_put_adapter(i2c_adap);
 	}
 
 	if (edid) {


