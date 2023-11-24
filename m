Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7ED039FFD;
	Fri, 24 Nov 2023 18:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hx+pA7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45F0FC433C7;
	Fri, 24 Nov 2023 18:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850256;
	bh=JI1i/ZauOX4/9BA8ayG/O95Xw4geM8kPun6fElVQD3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hx+pA7iv5OYuHeD3RcxFbfdoPXOR56canK5p3rolB2JNDWJN8euAJRixgSGLmeQf
	 qOivXGJ3ATI1J3/7H9e+h52wUKqxz+9VWnXxXZQcK18DDAvvI5QZuORHFhLcApHyce
	 xYoNxIFOaPCcGhHBygc11eTL7bwZmVQt4cSeuA40=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 507/530] drm/amd/pm: Handle non-terminated overdrive commands.
Date: Fri, 24 Nov 2023 17:51:13 +0000
Message-ID: <20231124172043.591944504@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 08e9ebc75b5bcfec9d226f9e16bab2ab7b25a39a upstream.

The incoming strings might not be terminated by a newline
or a 0.

(found while testing a program that just wrote the string
 itself, causing a crash)

Cc: stable@vger.kernel.org
Fixes: e3933f26b657 ("drm/amd/pp: Add edit/commit/show OD clock/voltage support in sysfs")
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -734,7 +734,7 @@ static ssize_t amdgpu_set_pp_od_clk_volt
 	if (adev->in_suspend && !adev->in_runpm)
 		return -EPERM;
 
-	if (count > 127)
+	if (count > 127 || count == 0)
 		return -EINVAL;
 
 	if (*buf == 's')
@@ -754,7 +754,8 @@ static ssize_t amdgpu_set_pp_od_clk_volt
 	else
 		return -EINVAL;
 
-	memcpy(buf_cpy, buf, count+1);
+	memcpy(buf_cpy, buf, count);
+	buf_cpy[count] = 0;
 
 	tmp_str = buf_cpy;
 
@@ -771,6 +772,9 @@ static ssize_t amdgpu_set_pp_od_clk_volt
 			return -EINVAL;
 		parameter_size++;
 
+		if (!tmp_str)
+			break;
+
 		while (isspace(*tmp_str))
 			tmp_str++;
 	}


