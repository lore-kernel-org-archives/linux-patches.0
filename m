Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940FA3EF672;
	Tue, 21 Jul 2026 17:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653670; cv=none; b=A1esrLbFCH1wGj6cUr4iZ3TMjUSfYqGeYjvhXbA54Mh3CdmRVTv6BpGEn0irYWB4JJHu5DQ3b1NLzvm2bf78JtSxu+rTbvrAJwf9ItMk5OK26EI2Tx0MgLtbe+xbl9uixfS0WmxPsD2uIl/ItxPi9FGB4MoLKb4LvvmVf0IgeOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653670; c=relaxed/simple;
	bh=wL8RtjpxK8LCkjvw+jJ56JlihMx2AAOq2VAlDo12peE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqpxC3vrOQoCrOAvhfMO96K5pox2S1mrkqZ3nl7QFHLLk3XYwioiapI3iMOUv0oFhdEsZ5UeuGx/ssNppSY1f0Oj5YkPEdIK8rq0R0Sm8Z1kqCCr478lrEGu8pVSBdgAqOKzFgWSYIXeLYEpfl85q6KPTKLDR+uZUkQ5RykCZQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZWdsHq3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZWdsHq3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FBE1F000E9;
	Tue, 21 Jul 2026 17:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653668;
	bh=FL/XPSi6aFsecq5I3ZDIB1a2en2JQZp3c+7E3IoQS+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZWdsHq3HkEkc2VPVLMwVCF0MlnLjpPSEZm3bnmx2Yzo5tUbPehbqy+H3gGjqWIqc
	 bwl9v3F/yH+u825OhnxTGABLrtEZj+szwIpK4mFLXTQmfisu6LiHstafZjvRdNokkB
	 yniwj1UXJz+FRp34P7ELo5oHlWANWNe1DykJ/RtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgiy Osokin <g.osokin@auroraos.dev>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1413/2077] HID: picolcd: prevent NULL pointer dereference in picolcd_send_and_wait()
Date: Tue, 21 Jul 2026 17:18:06 +0200
Message-ID: <20260721152626.135137017@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Georgiy Osokin <g.osokin@auroraos.dev>

[ Upstream commit 0021eb09041f021c079be1022934a280f7f176c0 ]

In picolcd_send_and_wait(), an integer overflow of the signed loop counter
'k' can theoretically lead to a NULL pointer dereference of 'raw_data'.
If the loop executes more than INT_MAX times, 'k' becomes negative,
making the condition 'k < size' true even when 'size' is 0.

Change the type of 'k' to 'unsigned int' to prevent the overflow and
eliminate the out-of-bounds access.

Found by Linux Verification Center (linuxtesting.org) with the Svace static
analysis tool.

[jkosina@suse.com: extended hash length]
Fixes: fabdbf2fd22fa17 ("HID: picoLCD: split driver code")
Signed-off-by: Georgiy Osokin <g.osokin@auroraos.dev>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-picolcd_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-picolcd_core.c b/drivers/hid/hid-picolcd_core.c
index 2cc01e1bc1a844..d73e97c8b853e9 100644
--- a/drivers/hid/hid-picolcd_core.c
+++ b/drivers/hid/hid-picolcd_core.c
@@ -72,7 +72,8 @@ struct picolcd_pending *picolcd_send_and_wait(struct hid_device *hdev,
 	struct picolcd_pending *work;
 	struct hid_report *report = picolcd_out_report(report_id, hdev);
 	unsigned long flags;
-	int i, j, k;
+	int i, j;
+	unsigned int k;
 
 	if (!report || !data)
 		return NULL;
-- 
2.53.0



