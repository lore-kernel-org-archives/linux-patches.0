Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4FF122488E;
	Thu, 12 Dec 2024 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021105; cv=none; b=cDzOnZBtnfE0NXszzwKzxFmst2omqqYuokYtXCNaG0reRXwpUixdVdrsvvYjCP43bBuNpMHc1VzhU29aRDAnHGrZ2IWSwAs/cPmvA9kf3fKOiRjei6TCswAub6QKWltmI5LwZ6xbNXw/HiU1qiUfzrJWQVXAuOQ215ddV/DXLr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021105; c=relaxed/simple;
	bh=HybcYvqEWBvJ3b11h608hmUS5dlpDLH34LSIcxv/5i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oZdKhdy6PtkazyRT9ojV+TCyPzZHYAm6Fvd4nJbexwwpkAPgENV31M19lJSjxUWzc62eGzF3/h6GmgFXqZTwoxQOLxOVR+E9jD3GYbvIt9PBm/MQNf3a+MJLO1sQISsqz4jjkQ+/5Vxj6SI5LAD6KPtgzoLz3FpDMTlagSdOLOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBbBuVmB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBbBuVmB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D683C4CECE;
	Thu, 12 Dec 2024 16:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021105;
	bh=HybcYvqEWBvJ3b11h608hmUS5dlpDLH34LSIcxv/5i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBbBuVmB6STs3koc51Cfn398sYrJXKfqVZ6LHqo24SgwiIMQoZg5HiZCDGoMCW55V
	 Viz7ogp5eDH1RhkJleB83MJUx+79fdnBJVRneO2dOYWLk1ZmSIBOjMAwsLxxiehYKM
	 Wv2iPU6nEKNMk1j9LEbOQmUzAqZICFtPWqL2PktE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 645/772] kselftest/arm64: Dont leak pipe fds in pac.exec_sign_all()
Date: Thu, 12 Dec 2024 15:59:50 +0100
Message-ID: <20241212144416.579136585@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 27141b690547da5650a420f26ec369ba142a9ebb ]

The PAC exec_sign_all() test spawns some child processes, creating pipes
to be stdin and stdout for the child. It cleans up most of the file
descriptors that are created as part of this but neglects to clean up the
parent end of the child stdin and stdout. Add the missing close() calls.

Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20241111-arm64-pac-test-collisions-v1-1-171875f37e44@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/pauth/pac.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/arm64/pauth/pac.c b/tools/testing/selftests/arm64/pauth/pac.c
index b743daa772f55..5a07b3958fbf2 100644
--- a/tools/testing/selftests/arm64/pauth/pac.c
+++ b/tools/testing/selftests/arm64/pauth/pac.c
@@ -182,6 +182,9 @@ int exec_sign_all(struct signatures *signed_vals, size_t val)
 		return -1;
 	}
 
+	close(new_stdin[1]);
+	close(new_stdout[0]);
+
 	return 0;
 }
 
-- 
2.43.0



