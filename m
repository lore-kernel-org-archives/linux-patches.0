Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38018563FB0;
	Wed,  9 Sep 2026 14:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964065; cv=none; b=J/KwyBYtywzr6h6RMl4ahVDOUtklwD1tFiKbv2LFirl3Q4x+CfYkx0nNpjSYifrAAdoqP27gxErxMquhDfMDzX1g4AH0KWfo0wsxALJU+hlEqUSNz/e1QFM8KFBE7j4JrQr5cpPXknTPwQKxYslxffYI0EULpTTFoeUxIScOWNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964065; c=relaxed/simple;
	bh=p5uT16X/yHUzhSmls71bJgVxb5dFAaAfkp3yGutOBkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLqZWOmp9Em8PcfBWSiGzdg6Xnb68SVTvWpY+H1qpi2YkJrC8pSlolYPG+ctuCuk823q+hbJF512VaAFapIon5qdY9HK6KF3KLcK5kdTBx5y9uXu5qIwpae33lCwdU3sHKzV/RcZ4GYc59gL85BTUjOljCa6H8lOYn9tqdkzvPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bFxtZHc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bFxtZHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AE91F00A3A;
	Wed,  9 Sep 2026 14:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964063;
	bh=PkZHK1HkRTI5AkWz90qKv+gwdnkbbAnDMYFWo028NwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bFxtZHcXbyp3yoWgDN4cDM43M4s0CCD4lYe0rYEu0dO4xgc9FGjYebdEQHgC0kZX
	 uVns9cuA95KSRbSQJNT7ls6cUMVtk3gqoGY4emvc5UFKBifDuzCdi0r1WvYVbJThZy
	 W1OotWqmSRoK64EcdSOV7mFen3FXruOXQ3LIcDvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.18 294/583] media: intel/ipu6: fix async notifier cleanup leak on parse error
Date: Wed,  9 Sep 2026 15:39:39 +0200
Message-ID: <20260909134248.218045801@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Nguyen <congnt264@gmail.com>

commit abb1f808ceab5a3275f8a6b4e37cff17f9f781c1 upstream.

isys_notifier_init() calls v4l2_async_nf_init() and then adds fwnode
remote subdevs in a loop with v4l2_async_nf_add_fwnode_remote(). If an
endpoint parse or add fails partway through the loop, it jumps to
err_parse and returns without calling v4l2_async_nf_cleanup(), leaking
every v4l2_async_connection already added to the notifier's waiting
list.

The register-failure path just below already cleans up correctly, and
the caller only tears the notifier down (isys_notifier_cleanup()) once
isys_notifier_init() has returned success. Clean up the notifier on the
parse error path too.

Fixes: f50c4ca0a820 ("media: intel/ipu6: add the main input system driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/intel/ipu6/ipu6-isys.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys.c
@@ -761,6 +761,7 @@ static int isys_notifier_init(struct ipu
 
 err_parse:
 		fwnode_handle_put(ep);
+		v4l2_async_nf_cleanup(&isys->notifier);
 		return ret;
 	}
 


