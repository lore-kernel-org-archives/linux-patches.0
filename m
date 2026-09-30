Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07415514757;
	Wed, 30 Sep 2026 16:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784563; cv=none; b=VYg27Gy0JNMCmbiYZFWzOrzHVPYX759Q03n3SnxGd3L4cYcUG2b2Jmh0XXLTzhD2+BGUaOzEWn6kxGKA5VCj/K6uQKGZN/y0Y0zJ7N1RLV7f22XOcPh0ZAvwUpxj+PqgdvFdFuH8xzisjyvPRyN6Xcn+i49J0h0ShDb3tLTFZHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784563; c=relaxed/simple;
	bh=E1NtFfZB49Av0htvp/Y05gowcAUJj3VBL3NMRbtxZJ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b6QlyaIzEJjEk2Pi6NI86zLFrdFhjg7ATYoVWgdWoOpc1ZTFJrjMpTDUCR83GeX7zGJeFHfOC6SvJDnKbDLMF5mLvVIUurIZ4d8TBuAR97CWgwsYO59Hiqg2Yy5TIaGLYzucgV7UoZKy4REkzVu1t6/w1KSSMichC1inaJNE5Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VJ3fM6hX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VJ3fM6hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F9E1F0089D;
	Wed, 30 Sep 2026 16:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784558;
	bh=X2C9NOcs8Gci4/xoOP8mqEc7uyfyCMA7JE501qw6bgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VJ3fM6hXQX+EBzW7nU7Fgt6Gpf7P/UjENOicqygDh4lvuFBvMpj3NBPoA0qaMKdXB
	 MXl0XzxUOnap/Ow2HWtdn/ke+RghvvgQ0eMFIKV36MoMI++Z9CoRxBUG1hp668sBgI
	 sPQbqmYOX7SDuYGnEYQ+NYmVE6ZBEtceBAffi434=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	zdi-disclosures@trendmicro.com,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 197/982] HID: hidpp: fix potential UAF in hidpp_connect_event()
Date: Wed, 30 Sep 2026 17:15:33 +0200
Message-ID: <20260930152421.045372337@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.com>

[ Upstream commit 6df6b1f2c49678211f65647c300bc51dda02893b ]

If input_register_device() fails, we call input_free_device(), but keep
stale pointer to the old device in hidpp->input, which could potentially
lead to UAF. Fix that by resetting it to NULL before returning from
hidpp_connect_event().

Reported-by: zdi-disclosures@trendmicro.com
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-logitech-hidpp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index eae0b0b46439d..1d4df88f690c0 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4056,6 +4056,7 @@ static void hidpp_connect_event(struct hidpp_device *hidpp)
 
 	ret = input_register_device(input);
 	if (ret) {
+		hidpp->input = NULL;
 		input_free_device(input);
 		return;
 	}
-- 
2.53.0



