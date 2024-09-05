Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8DD1494DB;
	Thu,  5 Sep 2024 10:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725530487; cv=none; b=mcCfztdoUj/Ur2Tj4MCBvIoabRagM1O0XdZfjkF07A4fr5ULqfUNFCqrokY81qOZ6LuuNlWuablHRmaclkW99vntAsElxFgAhDcsPZuTLyET05GTNj0Y4Rj/SafvDGQ7L3kS42uG1516U9O8NmcA7WsSHFFNB7YHa0VP+3cFllw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725530487; c=relaxed/simple;
	bh=u0cUi6/2mi9vOuszohlBNg0Y4CJ3JPZAkwIWfzl43gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJ747zgB1K2I5xnivdkquoyx4bkdexUDtbAiMe+UdCSGocUuT1ZN5cGnfu5ysxmvR/N+L5YBvvojYRDqL1qA7WuGjtdxaQk1unVX7XNFTZlprzLvsNy4KaFBBenUAMCyLqHe6UnwrLN4ld9F3o4E54/q5DwzjNV+EIE7IXGiP8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IeltvoL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IeltvoL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2EE9C4CEC4;
	Thu,  5 Sep 2024 10:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725530487;
	bh=u0cUi6/2mi9vOuszohlBNg0Y4CJ3JPZAkwIWfzl43gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IeltvoL/TLcioLCJJ7P3/58xlX6OKsf/r9lWzVmaud9t/mJq7/HUgn8gYUDzd7Hix
	 aEm3ZxF2ZZcU+C5vi5aJWNyyUVJU6wkeDJskIo/kDVhAUOlh0igTfvIrN+0QrQXby7
	 OWnZ8UoETkEuqxijp2CbZYE1ozdq8B0fizBoGYoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Tom Chung <chiahsuan.chung@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 040/101] drm/amd/display: Check gpio_id before used as array index
Date: Thu,  5 Sep 2024 11:41:12 +0200
Message-ID: <20240905093717.703805306@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240905093716.075835938@linuxfoundation.org>
References: <20240905093716.075835938@linuxfoundation.org>
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

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 2a5626eeb3b5eec7a36886f9556113dd93ec8ed6 ]

[WHY & HOW]
GPIO_ID_UNKNOWN (-1) is not a valid value for array index and therefore
should be checked in advance.

This fixes 5 OVERRUN issues reported by Coverity.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c b/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
index 3ede6e02c3a7..2f8ca831afa2 100644
--- a/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
+++ b/drivers/gpu/drm/amd/display/dc/gpio/gpio_service.c
@@ -239,6 +239,9 @@ static bool is_pin_busy(
 	enum gpio_id id,
 	uint32_t en)
 {
+	if (id == GPIO_ID_UNKNOWN)
+		return false;
+
 	return service->busyness[id][en];
 }
 
@@ -247,6 +250,9 @@ static void set_pin_busy(
 	enum gpio_id id,
 	uint32_t en)
 {
+	if (id == GPIO_ID_UNKNOWN)
+		return;
+
 	service->busyness[id][en] = true;
 }
 
@@ -255,6 +261,9 @@ static void set_pin_free(
 	enum gpio_id id,
 	uint32_t en)
 {
+	if (id == GPIO_ID_UNKNOWN)
+		return;
+
 	service->busyness[id][en] = false;
 }
 
@@ -263,7 +272,7 @@ enum gpio_result dal_gpio_service_lock(
 	enum gpio_id id,
 	uint32_t en)
 {
-	if (!service->busyness[id]) {
+	if (id != GPIO_ID_UNKNOWN && !service->busyness[id]) {
 		ASSERT_CRITICAL(false);
 		return GPIO_RESULT_OPEN_FAILED;
 	}
@@ -277,7 +286,7 @@ enum gpio_result dal_gpio_service_unlock(
 	enum gpio_id id,
 	uint32_t en)
 {
-	if (!service->busyness[id]) {
+	if (id != GPIO_ID_UNKNOWN && !service->busyness[id]) {
 		ASSERT_CRITICAL(false);
 		return GPIO_RESULT_OPEN_FAILED;
 	}
-- 
2.43.0



