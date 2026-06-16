Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B00443E4BA;
	Tue, 16 Jun 2026 16:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626958; cv=none; b=a3x7viO3iIBsG2JtxXfwQjCS9w52w7Cq5yBEIB70EZTQAy+h5K4n+f9ljHM93C6FJzgAtC8G/4rVWcNQo2jafd2cHC6WGd1X1oGAVc/iSYhSm6opFciaCtCYH50+hgKCqwf32bJJpdwAOguKbAZLkmqgOErLsam1IXS/mrMPwdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626958; c=relaxed/simple;
	bh=C9KmcNi2ZNeDCZRovNMGttKkf8XMP9KRgdBWnW5qWWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yy76QaEy5ollYh2jQ3FVPdgqvhJUA4uZEHDWOyH5YUmybNwlIkqOmNRSg2R+BeW9RIEjuvNU7/6fTk5nVNHCBYbT7iuQKpMMUxHZNKQeRyNvoM7r6xd50knEGjJAEblnc/VypDc6ipGxy9bUiI4PwSQdES0lv5U3dUrLBpeADUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mhuPkI/B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mhuPkI/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB871F000E9;
	Tue, 16 Jun 2026 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626957;
	bh=y2o3+W6NeIbGWC4Hbn/UBY28sYX8zJrUX0Ejol/5FjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mhuPkI/Bs3XB+2PIbILgyBdWys129iri32U+4fiGs5YAQfv5K47s1L5mbApaMpHqx
	 9VFk/7ZqmO7EbayaEyPZewSTY03AlAdoILx+wMeQj9smlFLUw42WoJ7tVHRGnMPNVt
	 JhhZspf+BeKc92V58wm7ttEqy44oXQklUFuoElN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nam Cao <namcao@linutronix.de>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/261] tools/rv: Fix cleanup after failed trace setup
Date: Tue, 16 Jun 2026 20:28:26 +0530
Message-ID: <20260616145048.283339840@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriele Monaco <gmonaco@redhat.com>

[ Upstream commit 33ec2269a4155cad7e9e42c92327dcaa9aee59a7 ]

Currently if ikm_setup_trace_instance() fails, the tool returns without
any cleanup, if rv was called with both -t and -r, this means the
reactor is not going to be cleared.

Jump to the cleanup label to restore the reactor if necessary.

Fixes: 6d60f89691fc9 ("tools/rv: Add in-kernel monitor interface")
Reviewed-by: Nam Cao <namcao@linutronix.de>
Link: https://lore.kernel.org/r/20260514152055.229162-5-gmonaco@redhat.com
Signed-off-by: Gabriele Monaco <gmonaco@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/verification/rv/src/in_kernel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/verification/rv/src/in_kernel.c b/tools/verification/rv/src/in_kernel.c
index ced72950cb1eed..64ae847313f6dc 100644
--- a/tools/verification/rv/src/in_kernel.c
+++ b/tools/verification/rv/src/in_kernel.c
@@ -655,7 +655,7 @@ int ikm_run_monitor(char *monitor_name, int argc, char **argv)
 	if (config_trace) {
 		inst = ikm_setup_trace_instance(monitor_name);
 		if (!inst)
-			return -1;
+			goto out_free_instance;
 	}
 
 	retval = ikm_enable(monitor_name);
-- 
2.53.0



