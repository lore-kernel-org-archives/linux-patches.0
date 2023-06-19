Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5CE5381
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A9CC433C8;
	Mon, 19 Jun 2023 10:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171395;
	bh=ilWEH3BtlOrYY29wnpH97XrWy7zVq/O5HyDySM8Ml0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSk5Hebgr6DxmTKlXCfrGVV2yG4AMsztbvHwd6zmdpMc/8mTRuw7virm6VeY/RsyS
	 eKZrhsgBWMLuD1nGyZ4fQcK5vOUYJCo3gaxRwe8l5yQ75zz/eYRTGwAhujG5S3JDK8
	 aGAKJW3wVoIcau79Q9eudapwz8q/vubbFx1xB6/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 016/166] selftests: gpio: gpio-sim: Fix BUG: test FAILED due to recent change
Date: Mon, 19 Jun 2023 12:28:13 +0200
Message-ID: <20230619102155.489030998@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>

[ Upstream commit 976d3c6778e99390c6d854d140b746d12ea18a51 ]

According to Mirsad the gpio-sim.sh test appears to FAIL in a wrong way
due to missing initialisation of shell variables:

 4.2. Bias settings work correctly
 cat: /sys/devices/platform/gpio-sim.0/gpiochip18/sim_gpio0/value: No such file or directory
 ./gpio-sim.sh: line 393: test: =: unary operator expected
 bias setting does not work
 GPIO gpio-sim test FAIL

After this change the test passed:

 4.2. Bias settings work correctly
 GPIO gpio-sim test PASS

His testing environment is AlmaLinux 8.7 on Lenovo desktop box with
the latest Linux kernel based on v6.2:

  Linux 6.2.0-mglru-kmlk-andy-09238-gd2980d8d8265 x86_64

Suggested-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Tested-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/gpio/gpio-sim.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/gpio/gpio-sim.sh b/tools/testing/selftests/gpio/gpio-sim.sh
index 341e3de008968..bf67b23ed29ac 100755
--- a/tools/testing/selftests/gpio/gpio-sim.sh
+++ b/tools/testing/selftests/gpio/gpio-sim.sh
@@ -389,6 +389,9 @@ create_chip chip
 create_bank chip bank
 set_num_lines chip bank 8
 enable_chip chip
+DEVNAME=`configfs_dev_name chip`
+CHIPNAME=`configfs_chip_name chip bank`
+SYSFS_PATH="/sys/devices/platform/$DEVNAME/$CHIPNAME/sim_gpio0/value"
 $BASE_DIR/gpio-mockup-cdev -b pull-up /dev/`configfs_chip_name chip bank` 0
 test `cat $SYSFS_PATH` = "1" || fail "bias setting does not work"
 remove_chip chip
-- 
2.39.2



