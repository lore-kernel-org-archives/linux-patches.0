Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E522A3D8917;
	Wed,  8 Apr 2026 18:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671649; cv=none; b=iV9VwLOXGG3wpAH0n3K6TiXnW2AsUmeXSEQDfnX3ag7FPiFM1JhWwhVrMW0krEyb3MPc3Do5+IJufVJkvdPAS7Qe21khSj+tMindo5S3TQXOXi4kZNp/MXlYETt1sVUFq6iv6EK4aFqSczwckkmiGi8/ErW6cRGpvcIYZGlf4WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671649; c=relaxed/simple;
	bh=1Gk/L0XL7/+NPNP0JLWmb8NRVdtZ5uZ0bec8G5uOKpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XFAcDCNj2jnuXV+ogoXxkAR0T56tFQ06Pk0nTog88qr3cgNC1dXPWSFgTwsY6YiQ3Fp2YqTdAWSrIruFnGE10eY3W/TGgLtJ5d4AP/NOIn9nXHBo4Nw/X9ynhCNlIX/UWRyReIU9lEaPgifWtci+QesKweJk2cqjbfiRc9mYZIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bx/4/2uN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bx/4/2uN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A06FC19421;
	Wed,  8 Apr 2026 18:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671648;
	bh=1Gk/L0XL7/+NPNP0JLWmb8NRVdtZ5uZ0bec8G5uOKpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bx/4/2uNET5Q4Phe2Ao1LecDfXj9rbQ0JVYXOY8JSZUv3LvKYnGb9zVot2hMaVPId
	 Z1fYLTo83tK9zU/+DUfmcA1Msk8D+C5ONl3x+nIm+Ouow5MUlj0bmLm+bJzZOboxZb
	 rHMj59iUva3b5g7maJVeMJYtLlHvWD3mn/kOmj5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/312] HID: asus: avoid memory leak in asus_report_fixup()
Date: Wed,  8 Apr 2026 19:58:40 +0200
Message-ID: <20260408175933.850163776@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Günther Noack <gnoack@google.com>

[ Upstream commit 2bad24c17742fc88973d6aea526ce1353f5334a3 ]

The asus_report_fixup() function was returning a newly allocated
kmemdup()-allocated buffer, but never freeing it.  Switch to
devm_kzalloc() to ensure the memory is managed and freed automatically
when the device is removed.

The caller of report_fixup() does not take ownership of the returned
pointer, but it is permitted to return a pointer whose lifetime is at
least that of the input buffer.

Also fix a harmless out-of-bounds read by copying only the original
descriptor size.

Assisted-by: Gemini-CLI:Google Gemini 3
Signed-off-by: Günther Noack <gnoack@google.com>
Signed-off-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-asus.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index ff301fd25725a..a95e47ce6d1e5 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -1206,14 +1206,21 @@ static __u8 *asus_report_fixup(struct hid_device *hdev, __u8 *rdesc,
 		 */
 		if (*rsize == rsize_orig &&
 			rdesc[offs] == 0x09 && rdesc[offs + 1] == 0x76) {
-			*rsize = rsize_orig + 1;
-			rdesc = kmemdup(rdesc, *rsize, GFP_KERNEL);
-			if (!rdesc)
-				return NULL;
+			__u8 *new_rdesc;
+
+			new_rdesc = devm_kzalloc(&hdev->dev, rsize_orig + 1,
+						 GFP_KERNEL);
+			if (!new_rdesc)
+				return rdesc;
 
 			hid_info(hdev, "Fixing up %s keyb report descriptor\n",
 				drvdata->quirks & QUIRK_T100CHI ?
 				"T100CHI" : "T90CHI");
+
+			memcpy(new_rdesc, rdesc, rsize_orig);
+			*rsize = rsize_orig + 1;
+			rdesc = new_rdesc;
+
 			memmove(rdesc + offs + 4, rdesc + offs + 2, 12);
 			rdesc[offs] = 0x19;
 			rdesc[offs + 1] = 0x00;
-- 
2.51.0



