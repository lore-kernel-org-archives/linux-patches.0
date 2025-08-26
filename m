Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34F4F299959;
	Tue, 26 Aug 2025 11:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207252; cv=none; b=lb5WN2aj0jrDo7iaUg6npkVifd1/7Oddn8I0yXeAVlVyI5VF4eHMoTp2/5lPsJc5bh3vJY6DZjUXWALSpneh4O9jMuO0buM6C8TQExg/6dt2oDy4auci936pd+gpyHigvLqWpcHvUr6GoHbGVkYbhcCDbg1VJMt/NaK2d0+dWsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207252; c=relaxed/simple;
	bh=Ru+y4B9xzfuqIAxAyh/v5YySM1y8D1rAdBcjljYe3cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qYo53bod1hlAwW+3/b1Pl2kMF6nh2oGPjOwVU2VclJUw+67B75vl6cHYI8YwRwV9zXkLJlcxsISf13phqJMnRlOEK5DfcRApqEqv3j3DVpuCBtiQgx71hF1Q375p2tXfqnDE+eDVQEdasEH9ElM3IOQ+dRln3xzxsB8JwMXnjyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFWKGgUc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFWKGgUc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFDC0C4CEF1;
	Tue, 26 Aug 2025 11:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207252;
	bh=Ru+y4B9xzfuqIAxAyh/v5YySM1y8D1rAdBcjljYe3cU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFWKGgUcmsc1q70ZW07AYbBtpVGkovz31kPGfvum+HJNVZm95xSfhh/seVmX6dsCl
	 nwVwf3eQ5rS6Ybkh9CmYAoJ2qA9tKJpktUxmT54rVIot426FLMhTdOREd7cieq6obb
	 HCBPrvoY1UZHWWrAUYgRAlsfgD9bWi6IQztW+BUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xaver Hugl <xaver.hugl@kde.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 108/457] amdgpu/amdgpu_discovery: increase timeout limit for IFWI init
Date: Tue, 26 Aug 2025 13:06:32 +0200
Message-ID: <20250826110940.041520707@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xaver Hugl <xaver.hugl@kde.org>

commit 928587381b54b1b6c62736486b1dc6cb16c568c2 upstream.

With a timeout of only 1 second, my rx 5700XT fails to initialize,
so this increases the timeout to 2s.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3697
Signed-off-by: Xaver Hugl <xaver.hugl@kde.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 9ed3d7bdf2dcdf1a1196630fab89a124526e9cc2)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_discovery.c
@@ -276,7 +276,7 @@ static int amdgpu_discovery_read_binary_
 	u32 msg;
 
 	if (!amdgpu_sriov_vf(adev)) {
-		/* It can take up to a second for IFWI init to complete on some dGPUs,
+		/* It can take up to two second for IFWI init to complete on some dGPUs,
 		 * but generally it should be in the 60-100ms range.  Normally this starts
 		 * as soon as the device gets power so by the time the OS loads this has long
 		 * completed.  However, when a card is hotplugged via e.g., USB4, we need to
@@ -284,7 +284,7 @@ static int amdgpu_discovery_read_binary_
 		 * continue.
 		 */
 
-		for (i = 0; i < 1000; i++) {
+		for (i = 0; i < 2000; i++) {
 			msg = RREG32(mmMP0_SMN_C2PMSG_33);
 			if (msg & 0x80000000)
 				break;


