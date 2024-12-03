Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4E251E3DF9;
	Tue,  3 Dec 2024 16:13:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242427; cv=none; b=DPKg7i3X0aVC7MqH2pZwY1LLOJJUamjfIEP4FVtUZ+PXzBfpNfEFc7igMxjKWGLWQJfEgZJX/vFoCLV/hekFheoSMo7SDwIgTeM2Qxqbq1R+P36uzcSGvTqzOdPqdGmsCgn4sGkCRqKjSOgOaipRMkn7iOAYM0eL2i2cxRVCv50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242427; c=relaxed/simple;
	bh=zqf/ixm2dX7y/MmYrsXvZRDedPyFOdCV+e2PXQxvCe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CuXc3RJ94fjUi1qVN2uhsZ2EcVeSls45c3VCaNERLMSBCNGpRklVQhqw/3v2xlPdoaJcVCHxQ4WiXnAGqxdTHq35p4uprKKD3E/3fBtFCNZjWOOp0xtCCsaxZlKxa3iJilvx0Ulawznqp7Pilpv8w/1DnjCBkbeIQu+ZOg0nUL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Buh4cx1s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Buh4cx1s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45442C4CECF;
	Tue,  3 Dec 2024 16:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242427;
	bh=zqf/ixm2dX7y/MmYrsXvZRDedPyFOdCV+e2PXQxvCe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Buh4cx1sRvgFt6zJRfSlKmf+WI//woNLiHVoC/9HhP/tts0n29fusf32QnExnhtkf
	 ZYJt9adkK17FW3CAMG6RkOb4jc/vTobgNwH6f9UmOiapCA9i2I++X5GA6eG/y0GnQ8
	 G0wvwT1AY8+Zd1e68XV4fMd9IvUq7TQUGCQtFzRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksei Vetrov <vvvvvv@google.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.12 683/826] wifi: nl80211: fix bounds checker error in nl80211_parse_sched_scan
Date: Tue,  3 Dec 2024 15:46:50 +0100
Message-ID: <20241203144810.401366786@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Aleksei Vetrov <vvvvvv@google.com>

commit 9c46a3a5b394d6d123866aa44436fc2cd342eb0d upstream.

The channels array in the cfg80211_scan_request has a __counted_by
attribute attached to it, which points to the n_channels variable. This
attribute is used in bounds checking, and if it is not set before the
array is filled, then the bounds sanitizer will issue a warning or a
kernel panic if CONFIG_UBSAN_TRAP is set.

This patch sets the size of allocated memory as the initial value for
n_channels. It is updated with the actual number of added elements after
the array is filled.

Fixes: aa4ec06c455d ("wifi: cfg80211: use __counted_by where appropriate")
Cc: stable@vger.kernel.org
Signed-off-by: Aleksei Vetrov <vvvvvv@google.com>
Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Link: https://patch.msgid.link/20241029-nl80211_parse_sched_scan-bounds-checker-fix-v2-1-c804b787341f@google.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/nl80211.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9776,6 +9776,7 @@ nl80211_parse_sched_scan(struct wiphy *w
 	request = kzalloc(size, GFP_KERNEL);
 	if (!request)
 		return ERR_PTR(-ENOMEM);
+	request->n_channels = n_channels;
 
 	if (n_ssids)
 		request->ssids = (void *)request +


