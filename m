Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EBB0154449;
	Fri,  6 Dec 2024 15:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498661; cv=none; b=AumQamHtau2HP/677/ytXIWudtwqIs59YuQkhqr+hu6otC1bYtYELH/Bt8+vcgdhrxBnhuNrzfVt8fyTUsn26OcUdrsEbxkPvmD2P0/72RjEhPsA87OgvBYrYNdO98liXuaOKcDh+rEYYShyYkLmuKhiTwMGbdV1AnooqDmEbT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498661; c=relaxed/simple;
	bh=MjqxAfiWQ9jAkU1EMjNx6yZdMwSBMf7FajJDJG0Pg+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEysOqN2C90JlUCjSBYLAlkRE11X0Waq8g7DUbzBaCPFVWvmR1SOp4rz7ROIXCno5q7nO/0niY2Vx5WkQXmXtYM9Of3v+DRCgpFsp77vm3tdi9PvhdpeiU/NFINQb1UNpVNkUh2/p2F3GENuGrbI/6lHTto+kBSYCTnjdDDT0FY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RPNlggbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RPNlggbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08BB2C4CED1;
	Fri,  6 Dec 2024 15:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498661;
	bh=MjqxAfiWQ9jAkU1EMjNx6yZdMwSBMf7FajJDJG0Pg+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RPNlggbPsZavYgfD67cHM0SCYfuyXFMMQlNRu+vDFd3ebxaRj3ewvUSBsBO7T2f+I
	 tz7Z0kSTIUivAaAru6/oP9OjUYZ1/6+WotO7cDJ3mwB9XlKiasa8jDYnwOOLF62Itb
	 gITQGXJ8twPWIGm47UXmdu5ZRZcJyE4/Y3/bVuFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 649/676] thermal: int3400: Fix reading of current_uuid for active policy
Date: Fri,  6 Dec 2024 15:37:48 +0100
Message-ID: <20241206143718.718654638@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit 7082503622986537f57bdb5ef23e69e70cfad881 upstream.

When the current_uuid attribute is set to the active policy UUID,
reading back the same attribute is returning "INVALID" instead of
the active policy UUID on some platforms before Ice Lake.

In platforms before Ice Lake, firmware provides a list of supported
thermal policies. In this case, user space can select any of the
supported thermal policies via a write to attribute "current_uuid".

In commit c7ff29763989 ("thermal: int340x: Update OS policy capability
handshake")', the OS policy handshake was updated to support Ice Lake
and later platforms and it treated priv->current_uuid_index=0 as
invalid. However, priv->current_uuid_index=0 is for the active policy,
only priv->current_uuid_index=-1 is invalid.

Fix this issue by updating the priv->current_uuid_index check.

Fixes: c7ff29763989 ("thermal: int340x: Update OS policy capability handshake")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: 5.18+ <stable@vger.kernel.org> # 5.18+
Link: https://patch.msgid.link/20241114200213.422303-1-srinivas.pandruvada@linux.intel.com
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -144,7 +144,7 @@ static ssize_t current_uuid_show(struct
 	struct int3400_thermal_priv *priv = dev_get_drvdata(dev);
 	int i, length = 0;
 
-	if (priv->current_uuid_index > 0)
+	if (priv->current_uuid_index >= 0)
 		return sprintf(buf, "%s\n",
 			       int3400_thermal_uuids[priv->current_uuid_index]);
 


