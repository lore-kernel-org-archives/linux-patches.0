Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 712681A08A3;
	Tue, 27 Aug 2024 15:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770893; cv=none; b=OIzEXnYIAHt4UlsSF+tMZTRBVU1+DVHoRBJLDYTTRdLtEoQRvCyJXouWRXA8CBjWl1YOQ5z8eazPE+hxMRCEQh50Xo+aysJbvPLzrINt/3WXDf48AtQ5SEE0wx7y3fo4QDFxGb5MLlFEo3NmZ2cyDLOjxaxKQ3YNbYxxtV7juf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770893; c=relaxed/simple;
	bh=tM8Yf03nqhb473X/a3vR2NvB/U2YLRex7KccIZlFVuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u1w+ViEMv5LfG9axobdfXrRuR23aBVp+raKTRdKwEBPQNycSTu3ZepwjuKHHYtdf3LMeDzf+VEXlTdYvCTNwQrhNHV6wo9dMqF53VxvSVIqqdLhD6+frOvJ0OAF3SXHOwSYKgq2yGqOTH4NEqPq9ZjHj8VzmRAlBpgDxdwBh+MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtbGFxcq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtbGFxcq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7BBDC4DDEF;
	Tue, 27 Aug 2024 15:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770893;
	bh=tM8Yf03nqhb473X/a3vR2NvB/U2YLRex7KccIZlFVuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtbGFxcq0CZD9x00Cw2v1Mv2h7vzU84CmhgMMDlMuybRZ9A5a2hsx6isWtAYfV59G
	 gqeJKOWwQ9yj7sXOWvMDUzk1rQKVSQEZcKp+k0MlJt3q4kT6+uvwkCmtDaQ7BhtZGD
	 kcJbNBjBW6yPeepFxiOJEp+Ckus0/lQaXAXoaSkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Peter=20K=C3=A4stle?= <peter@piie.net>,
	Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH 6.10 024/273] thermal: gov_bang_bang: Call __thermal_cdev_update() directly
Date: Tue, 27 Aug 2024 16:35:48 +0200
Message-ID: <20240827143834.309705472@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit b9b6ee6fe258ce4d89592593efcd3d798c418859 upstream.

Instead of clearing the "updated" flag for each cooling device
affected by the trip point crossing in bang_bang_control() and
walking all thermal instances to run thermal_cdev_update() for all
of the affected cooling devices, call __thermal_cdev_update()
directly for each of them.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Peter Kästle <peter@piie.net>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.10+ <stable@vger.kernel.org> # 6.10+
Link: https://patch.msgid.link/13583081.uLZWGnKmhe@rjwysocki.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/gov_bang_bang.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/drivers/thermal/gov_bang_bang.c
+++ b/drivers/thermal/gov_bang_bang.c
@@ -79,12 +79,9 @@ static void bang_bang_control(struct the
 		dev_dbg(&instance->cdev->device, "target=%ld\n", instance->target);
 
 		mutex_lock(&instance->cdev->lock);
-		instance->cdev->updated = false; /* cdev needs update */
+		__thermal_cdev_update(instance->cdev);
 		mutex_unlock(&instance->cdev->lock);
 	}
-
-	list_for_each_entry(instance, &tz->thermal_instances, tz_node)
-		thermal_cdev_update(instance->cdev);
 }
 
 static struct thermal_governor thermal_gov_bang_bang = {


