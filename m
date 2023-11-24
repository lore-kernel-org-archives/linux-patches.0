Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C67633CCA;
	Fri, 24 Nov 2023 18:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="12+lDj5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2954DC433C8;
	Fri, 24 Nov 2023 18:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851103;
	bh=mg+Skvr0nske2Txva6fcijWBijT1aLLLQwOVhcJkRrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=12+lDj5CLIrnriUrRzIYAK/0kBMoQtgD0Lz+6OvglvJY8ZBHl5O8qU/6VjAwdu9ek
	 zgUtGo14TWQX2RvUARw8DdERE37rDEXx8I802FU7Df7nv8nC726iHSVXu6ZlmBRUmB
	 HLO9r6W7qcweAOqCK6Rt/yM9l4bxya5PeXdfqkjY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Arcari <darcari@redhat.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.5 315/491] thermal: intel: powerclamp: fix mismatch in get function for max_idle
Date: Fri, 24 Nov 2023 17:49:11 +0000
Message-ID: <20231124172034.039792218@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Arcari <darcari@redhat.com>

commit fae633cfb729da2771b5433f6b84ae7e8b4aa5f7 upstream.

KASAN reported this

      [ 444.853098] BUG: KASAN: global-out-of-bounds in param_get_int+0x77/0x90
      [ 444.853111] Read of size 4 at addr ffffffffc16c9220 by task cat/2105
      ...
      [ 444.853442] The buggy address belongs to the variable:
      [ 444.853443] max_idle+0x0/0xffffffffffffcde0 [intel_powerclamp]

There is a mismatch between the param_get_int and the definition of
max_idle.  Replacing param_get_int with param_get_byte resolves this
issue.

Fixes: ebf519710218 ("thermal: intel: powerclamp: Add two module parameters")
Cc: 6.3+ <stable@vger.kernel.org> # 6.3+
Signed-off-by: David Arcari <darcari@redhat.com>
Reviewed-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/intel_powerclamp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index 36243a3972fd..5ac5cb60bae6 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -256,7 +256,7 @@ static int max_idle_set(const char *arg, const struct kernel_param *kp)
 
 static const struct kernel_param_ops max_idle_ops = {
 	.set = max_idle_set,
-	.get = param_get_int,
+	.get = param_get_byte,
 };
 
 module_param_cb(max_idle, &max_idle_ops, &max_idle, 0644);
-- 
2.43.0



