Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6169B26773A;
	Tue,  8 Apr 2025 12:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113796; cv=none; b=VOF4E3UMa+iP+UN+VeP812Jj7wqmp63Tp7PewxJ5aybIm+diJwLv0VOLYPXfsBwTg+EGoIPfNGSYO9exiqcL7Lb7efK2RgYcGL5HR25LaZsKUXaLoAupvmL+1UhHJ3i3wZbotzUavK8u24odkVBKjND4OLHF8CYfQTC1XTaAbCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113796; c=relaxed/simple;
	bh=0H4rPK+xv2nFxkds6X8ygG155GPc5EUqUPLYwRjw484=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ia1vCxBwTpHN3Q9lSyd0CNK59pteVPCgeUzKfrJKBrU3HrSIlMmV3PMOa+WS6LMUMy4TebZ4itYkn6mYJOjY1GeBd1Nd03M14bkTgeoy7Q9AkVPr8utnCBACAYgp6a+uSpD2/uGagVPM1PCQMbd8Y2VGQbAHvoDZ0xmym8xP3qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d1O2w3tT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d1O2w3tT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E2CC4CEE5;
	Tue,  8 Apr 2025 12:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113796;
	bh=0H4rPK+xv2nFxkds6X8ygG155GPc5EUqUPLYwRjw484=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1O2w3tTD1wKPbGNvCJSHPqZ1nVQfp+kR++sJAMTDxljXK/1aD76AjR3TtAllaWIR
	 GKHaFms5AIEmmO+5EneeJ+ErlKp/P4+nRszrDqaMqSJKAL8YQbwKAcBg2f9y2fFGo/
	 /GHQ5sQcVbnjmNzRPPOiDokUWEaLwZEW7YrOhayE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/154] powercap: call put_device() on an error path in powercap_register_control_type()
Date: Tue,  8 Apr 2025 12:49:24 +0200
Message-ID: <20250408104816.017784926@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit 93c66fbc280747ea700bd6199633d661e3c819b3 ]

powercap_register_control_type() calls device_register(), but does not
release the refcount of the device when it fails.

Call put_device() before returning an error to balance the refcount.

Since the kfree(control_type) will be done by powercap_release(), remove
the lines in powercap_register_control_type() before returning the error.

This bug was found by an experimental verifier that I am developing.

Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20250110010554.1583411-1-joe@pf.is.s.u-tokyo.ac.jp
[ rjw: Changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/powercap_sys.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index 7a3109a538813..fe5d05da7ce7a 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -627,8 +627,7 @@ struct powercap_control_type *powercap_register_control_type(
 	dev_set_name(&control_type->dev, "%s", name);
 	result = device_register(&control_type->dev);
 	if (result) {
-		if (control_type->allocated)
-			kfree(control_type);
+		put_device(&control_type->dev);
 		return ERR_PTR(result);
 	}
 	idr_init(&control_type->idr);
-- 
2.39.5



