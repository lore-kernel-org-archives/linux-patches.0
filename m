Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2937C1EF38C;
	Tue, 12 Aug 2025 18:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023069; cv=none; b=YC7IIDMzVyOU/EIzqWbCqWQhj2Vh5AMitWZQvDwjw5qMTEXEm0NVFPJOnpCRRE8L0Jay7ZM+gpk49+LnvIacxpajCIevFB3nvT6lwms5v9uDxZtTx0FQvhqREZEgJBmGBAQryOpASOQ83pJlv8//8z0UyG3zHpsMxWGNd6TVNpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023069; c=relaxed/simple;
	bh=9FS3K6pBzi5oEkI7xxLsU0iiebJXwCz3epO+QYXvBJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mjExR0KPqp333kGBLqYJK0s5LqVF3pZelw4t2u9h4ftIqmbFppY0Vqy8s2AT1dcO7Gg8WfYQ3jGdRGPmfqYB7HP1ilcE4PBONwO9u3QLFki0F74pv0WkOqarA38hpadpKVHMYu+uRr6oVYql9Ard1vlWwqP/FgbAoFgDHbhA3OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzvg4LCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzvg4LCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84413C4CEFA;
	Tue, 12 Aug 2025 18:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023069;
	bh=9FS3K6pBzi5oEkI7xxLsU0iiebJXwCz3epO+QYXvBJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vzvg4LCEGd2H66zfxK0e4RDX4b6s0gv1mi/zkoFkHjhevu9sSVH9xR2MPbyyOTlF7
	 OLgrkYDH6Axr1KInSXYtgbRrUbkn9mpFtzz08kDoQ5eoKd0edL4CVRCUvEkQnYg9Zl
	 25drEmj3alyQ6JyOjOoUpih05MbmlDpAmcKURbxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Ville Syrjala <ville.syrjala@linux.intel.com>,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.12 340/369] drm/i915/ddi: only call shutdown hooks for valid encoders
Date: Tue, 12 Aug 2025 19:30:37 +0200
Message-ID: <20250812173029.488620908@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jani Nikula <jani.nikula@intel.com>

commit 60a43ecbd59decb77b31c09a73f09e1d4f4d1c4c upstream.

DDI might be HDMI or DP only, leaving the other encoder
uninitialized. Calling the shutdown hook on an uninitialized encoder may
lead to a NULL pointer dereference. Check the encoder types (and thus
validity via the DP output_reg or HDMI hdmi_reg checks) before calling
the hooks.

Reported-and-tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Closes: https://lore.kernel.org/r/20241031105145.2140590-1-senozhatsky@chromium.org
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Ville Syrjala <ville.syrjala@linux.intel.com>
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/8b197c50e7f3be2bbc07e3935b21e919815015d5.1735568047.git.jani.nikula@intel.com
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_ddi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_ddi.c
+++ b/drivers/gpu/drm/i915/display/intel_ddi.c
@@ -4798,8 +4798,10 @@ static void intel_ddi_tc_encoder_suspend
 
 static void intel_ddi_encoder_shutdown(struct intel_encoder *encoder)
 {
-	intel_dp_encoder_shutdown(encoder);
-	intel_hdmi_encoder_shutdown(encoder);
+	if (intel_encoder_is_dp(encoder))
+		intel_dp_encoder_shutdown(encoder);
+	if (intel_encoder_is_hdmi(encoder))
+		intel_hdmi_encoder_shutdown(encoder);
 }
 
 static void intel_ddi_tc_encoder_shutdown_complete(struct intel_encoder *encoder)


