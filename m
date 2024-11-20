Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09481AB6C0;
	Wed, 20 Nov 2024 12:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107564; cv=none; b=l4qCHXO+//GLhKMngGb5Ckk0U5zOb9VRjDBBajtLr7lelUbgMofTrLjIIEKhWm2PlgCYvaF4hpaAkCRC4wtMfEpNv03H0o0K2BTKz4p9vU9/Nb06aUJFw8lE3yniWl/PyfWGpB2OcRPfXc2NcyOSQ7sOIpUK3gDBkbVAPIvIQnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107564; c=relaxed/simple;
	bh=Rua3aVXMNGREC2fpNcwAUgux/NnulmLiaJBk1/ctpL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ty+447cuEtg3zInyMjZ02cUX4L+NtNJO8HxERqFOIh7NBVeck4UbFAMZ5IpYn6Hk0exJ2PYp1DTOM2fI8iA1k42HCEbns5IwJhDrmHIC1tp0v3553w5Pek8lJhpRYpFbgL7lFelmOPRtfnXLXhZdBzTSuYYIGv32D/ZBrMb0y2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=viDeKaoI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="viDeKaoI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD993C4CECD;
	Wed, 20 Nov 2024 12:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107563;
	bh=Rua3aVXMNGREC2fpNcwAUgux/NnulmLiaJBk1/ctpL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=viDeKaoISfIBWQnWL6jYQ3tI515/+nJnwYnEHtwR+jbTNVuJgIwyK494zULQW8UMs
	 m1B00mHG3OmM+znJa6l96kC9OjX/6UIyxpeb7KykLjajQjDt7dTKorb3nKB8+X5T+F
	 /TRANYlB1jXQJsCAUW8PigHAVgV+tU7Tz2K3nzRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ferrieux <alexandre.ferrieux@orange.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.11 106/107] net: sched: u32: Add test case for systematic hnode IDR leaks
Date: Wed, 20 Nov 2024 13:57:21 +0100
Message-ID: <20241120125632.132113884@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Ferrieux <alexandre.ferrieux@gmail.com>

commit ca34aceb322bfcd6ab498884f1805ee12f983259 upstream.

Add a tdc test case to exercise the just-fixed systematic leak of
IDR entries in u32 hnode disposal. Given the IDR in question is
confined to the range [1..0x7FF], it is sufficient to create/delete
the same filter 2048 times to fill it up and get a nonzero exit
status from "tc filter add".

Signed-off-by: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20241113100428.360460-1-alexandre.ferrieux@orange.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/tc-testing/tc-tests/filters/u32.json |   24 +++++++++++
 1 file changed, 24 insertions(+)

--- a/tools/testing/selftests/tc-testing/tc-tests/filters/u32.json
+++ b/tools/testing/selftests/tc-testing/tc-tests/filters/u32.json
@@ -329,5 +329,29 @@
         "teardown": [
             "$TC qdisc del dev $DEV1 parent root drr"
         ]
+    },
+    {
+        "id": "1234",
+        "name": "Exercise IDR leaks by creating/deleting a filter many (2048) times",
+        "category": [
+            "filter",
+            "u32"
+        ],
+        "plugins": {
+            "requires": "nsPlugin"
+        },
+        "setup": [
+            "$TC qdisc add dev $DEV1 parent root handle 10: drr",
+            "$TC filter add dev $DEV1 parent 10:0 protocol ip prio 2 u32 match ip src 0.0.0.2/32 action drop",
+            "$TC filter add dev $DEV1 parent 10:0 protocol ip prio 3 u32 match ip src 0.0.0.3/32 action drop"
+        ],
+        "cmdUnderTest": "bash -c 'for i in {1..2048} ;do echo filter delete dev $DEV1 pref 3;echo filter add dev $DEV1 parent 10:0 protocol ip prio 3 u32 match ip src 0.0.0.3/32 action drop;done | $TC -b -'",
+        "expExitCode": "0",
+        "verifyCmd": "$TC filter show dev $DEV1",
+        "matchPattern": "protocol ip pref 3 u32",
+        "matchCount": "3",
+        "teardown": [
+            "$TC qdisc del dev $DEV1 parent root drr"
+        ]
     }
 ]


