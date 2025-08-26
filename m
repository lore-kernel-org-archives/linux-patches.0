Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF1B267386;
	Tue, 26 Aug 2025 11:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207494; cv=none; b=rtkbCKt2zPkutNzJazkJRiUSeFUU9SF5LAVZkVdASO6P1C3B/WKYlUbSyqY1Yrb9C7mbDjFdpRTsXrjvgqw0eUrmNZfAtW4x1mYD1HCJyo6zH9PDKi+I57f8bmZV68dtqMrleGVubqDmy4DVJLWqRTX3XnrCRJ8M+VWEyKnstbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207494; c=relaxed/simple;
	bh=n8PZTup3s+VP6nAJu7PIXVOrJ/eYQIVgOzN87WKQK+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AO/G+PIqrQgE7fngcDTeWOgZcnLBVn/iAqekVOsZkm5wkSjjMryGnteBHjUL1M/1bBPnp/rnmCkhlnRfSFuS4xMe0P2hWl6/pjpzH8uh2z8+GU/LPRanH9UHSe4q78Nv1E5ETb2UBu9rKdfAyFW4rqLOfM1iWxdzlnZA9h+QKlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qQvn7UGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qQvn7UGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20956C4CEF4;
	Tue, 26 Aug 2025 11:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207494;
	bh=n8PZTup3s+VP6nAJu7PIXVOrJ/eYQIVgOzN87WKQK+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qQvn7UGM7cZN37V3ZVt2PWmxRC7E6Mkz6A+eqWwiOfvATB7zoHvsQoU3CkpPfAyZe
	 mxDjG2h3NUdzeMHzVv6Rs24xnOux5M4htj+hL0iTv3cqLiN1fZnpRIzciN4+P5L1Fk
	 //1Ex9uRqIz0lILlW47rnYl6lXLXJunAuIjb946U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.16 203/457] ACPI: APEI: EINJ: Fix resource leak by remove callback in .exit.text
Date: Tue, 26 Aug 2025 13:08:07 +0200
Message-ID: <20250826110942.384179737@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit b21d1fbb97c814c76ffa392cd603f8cd3ecc0355 upstream.

The .remove() callback is also used during error handling in
faux_probe(). As einj_remove() was marked with __exit it's not linked
into the kernel if the driver is built-in, potentially resulting in
resource leaks.

Also remove the comment justifying the __exit annotation which doesn't
apply any more since the driver was converted to the faux device
interface.

Fixes: 6cb9441bfe8d ("ACPI: APEI: EINJ: Transition to the faux device interface")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Cc: 6.16+ <stable@vger.kernel.org> # 6.16+
Link: https://patch.msgid.link/20250814051157.35867-2-u.kleine-koenig@baylibre.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/apei/einj-core.c |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

--- a/drivers/acpi/apei/einj-core.c
+++ b/drivers/acpi/apei/einj-core.c
@@ -842,7 +842,7 @@ err_put_table:
 	return rc;
 }
 
-static void __exit einj_remove(struct faux_device *fdev)
+static void einj_remove(struct faux_device *fdev)
 {
 	struct apei_exec_context ctx;
 
@@ -864,15 +864,9 @@ static void __exit einj_remove(struct fa
 }
 
 static struct faux_device *einj_dev;
-/*
- * einj_remove() lives in .exit.text. For drivers registered via
- * platform_driver_probe() this is ok because they cannot get unbound at
- * runtime. So mark the driver struct with __refdata to prevent modpost
- * triggering a section mismatch warning.
- */
-static struct faux_device_ops einj_device_ops __refdata = {
+static struct faux_device_ops einj_device_ops = {
 	.probe = einj_probe,
-	.remove = __exit_p(einj_remove),
+	.remove = einj_remove,
 };
 
 static int __init einj_init(void)


